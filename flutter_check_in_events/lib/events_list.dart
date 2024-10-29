import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_check_in_events/events_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyEventDetailsScreen extends StatefulWidget {
  final Event event;
  final String partiId;

  const MyEventDetailsScreen({
    super.key,
    required this.event,
    required this.partiId,
  });

  @override
  State<MyEventDetailsScreen> createState() => _MyEventDetailsScreenState();
}

class _MyEventDetailsScreenState extends State<MyEventDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _getUserLocationAndCheckIn() async {
    if (!await _checkLocationPermissions()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      LatLng eventLocation = _parseLocation(widget.event.local);

      double distanceInMeters = _calculateDistance(userLocation, eventLocation);

      if (distanceInMeters <= 50) {
        await _createFictitiousCheckIn(widget.event.id, userLocation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check-in realizado com sucesso!")),
        );
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
        title: Text(widget.event.nome),
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
                  // Adicionando a imagem do evento aqui
                  Image.network(
                    widget.event.image, // URL da imagem
                    fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço
                    width: double.infinity, // Largura total
                    height: 200, // Altura da imagem
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.event.nome,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Data e Hora: ${widget.event.data} ",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Localização: ${widget.event.local}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Status: ${widget.event.status}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Descrição:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.descricao,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, right: 16.0),
              child: ElevatedButton(
                onPressed:
                    _isLoading ? null : () => _getUserLocationAndCheckIn(),
                child: const Text('Fazer Check-in'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  backgroundColor: const Color.fromARGB(255, 50, 160, 211),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
