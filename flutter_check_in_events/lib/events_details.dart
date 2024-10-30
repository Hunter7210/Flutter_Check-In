import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_check_in_events/events_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyEventDetailsScreen extends StatefulWidget {
  final Event event;
  final String partiId;

  const MyEventDetailsScreen({
    Key? key,
    required this.event,
    required this.partiId,
  }) : super(key: key);

  @override
  State<MyEventDetailsScreen> createState() => _MyEventDetailsScreenState();
}

class _MyEventDetailsScreenState extends State<MyEventDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isInRange = false; // Variável para controlar o estado do range
  late LatLng eventLocation;
  List<int> ratings = [];

  @override
  void initState() {
    super.initState();
    eventLocation = _parseLocation(widget.event.local);
    _fetchRatings();
  }

  Future<void> _getUserLocationAndCheckIn() async {
    if (!await _checkLocationPermissions()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng userLocation = LatLng(position.latitude, position.longitude);
      double distanceInMeters = _calculateDistance(userLocation, eventLocation);

      setState(() {
        _isInRange =
            distanceInMeters <= 50; // Atualiza o estado baseado na distância
      });

      if (_isInRange) {
        await _createFictitiousCheckIn(widget.event.id, userLocation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check-in realizado com sucesso!")),
        );

        await _waitForUserToExitRadius(userLocation);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Você está a ${distanceInMeters.toStringAsFixed(2)} metros do evento. Aproximar-se!")),
        );
      }
    } catch (e) {
      print("Erro ao obter localização do usuário: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _waitForUserToExitRadius(LatLng initialLocation) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng userLocation = LatLng(position.latitude, position.longitude);
      double distanceInMeters = _calculateDistance(userLocation, eventLocation);

      setState(() {
        _isInRange =
            distanceInMeters <= 50; // Atualiza o estado baseado na distância
      });

      if (!_isInRange) {
        _showRatingDialog();
        break;
      }
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Avalie o Evento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: ratings.contains(index + 1)
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                    onPressed: () {
                      _saveRating(index + 1);
                      Navigator.of(context).pop();
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text("Avaliações:"),
              for (var rating in ratings)
                Text("⭐ ${rating.toString()} estrelas"),
            ],
          ),
        );
      },
    );
  }

  void _saveRating(int rating) async {
    await FirebaseFirestore.instance
        .collection('Evento')
        .doc(widget.event.id)
        .collection('Avaliacoes')
        .add({'estrelas': rating});
    _fetchRatings();
  }

  Future<void> _fetchRatings() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Evento')
        .doc(widget.event.id)
        .collection('Avaliacoes')
        .get();
    ratings = snapshot.docs.map((doc) => doc['estrelas'] as int).toList();
    setState(() {});
  }

  LatLng _parseLocation(String locationString) {
    List<String> parts = locationString.split(',');
    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());
    return LatLng(latitude, longitude);
  }

  Future<void> _createFictitiousCheckIn(
      String eventId, LatLng userLocation) async {
    Map<String, dynamic> fictitiousCheckInData = {
      'HorarioCheck': DateTime.now().toString(),
      'StatusCheck': 'Registrado',
      'LocalizacaoAtualCheck':
          '${userLocation.latitude}, ${userLocation.longitude}',
      'idUsu': widget.partiId,
    };

    await _firestore
        .collection('Evento')
        .doc(eventId)
        .collection('Check-in')
        .add(fictitiousCheckInData);
  }

  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Serviço de localização desativado!")),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permissão de localização negada!")),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permissão de localização permanentemente negada!")),
      );
      return false;
    }

    return true;
  }

  double _calculateDistance(LatLng userLocation, LatLng eventLocation) {
    final Distance distance = Distance();
    return distance(userLocation, eventLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.nome, style: const TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Carrossel com imagem e mapa
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView(
                        controller: PageController(
                          initialPage: 0,
                        ),
                        children: [
                          // Imagem do evento
                          Image.network(
                            widget.event.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          // Mapa do evento
                          FlutterMap(
                            options: MapOptions(
                              center: eventLocation,
                              zoom: 15.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: eventLocation,
                                    builder: (ctx) => const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome: ${widget.event.nome}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Descrição: ${widget.event.descricao}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Data e Hora: ${widget.event.data}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Localização: ${widget.event.local}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${widget.event.status}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botão de check-in no canto inferior direito
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _getUserLocationAndCheckIn,
                icon: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(Icons.check),
                label: const Text("Realizar Check-in"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      _isInRange ? Colors.green : Colors.red, // Mudança de cor
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
