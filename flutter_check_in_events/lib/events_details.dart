import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_check_in_events/events_list.dart';

class MyEventDetailsScreen extends StatefulWidget {
  final Event event;
  final String partiId;

  const MyEventDetailsScreen(
      {super.key, required this.event, required this.partiId});

  @override
  State<MyEventDetailsScreen> createState() => _MyEventDetailsScreenState();
}

class _MyEventDetailsScreenState extends State<MyEventDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false; // Adiciona um estado de loading

  Future<void> _createFictitiousCheckIn(String eventId) async {
    setState(() {
      _isLoading = true; // Ativa o loading
    });

    try {
      // Dados fictícios para o Check-in
      Map<String, dynamic> fictitiousCheckInData = {
        'NomeUsuario': 'Usuário Exemplo',
        'HorarioCheck': DateTime.now().toString(),
        'StatusCheck': 'Registrado',
        'LocalizacaoAtualCheck': '',
        'idUsu': widget.partiId,
      };

      // Adiciona um novo documento com os dados fictícios na subcoleção Check-in
      await _firestore
          .collection('Evento')
          .doc(eventId)
          /* .collection('Participantes')
          .doc(widget.partiId) */
          .collection('Check-in')
          .add(fictitiousCheckInData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check-in fictício criado com sucesso!")),
      );
    } catch (e) {
      print("Erro ao criar check-in fictício: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao criar check-in fictício.")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Desativa o loading
      });
    }
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
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
      ),
      body: Stack(
        // Usando Stack para sobrepor os widgets
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cartaz do evento com tamanho maior
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    /*    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        widget.event.imagem,
                        height: 400, // Aumentando a altura do cartaz
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons
                              .error); // Mostra um ícone de erro se a imagem não for carregada
                        },
                      ),
                    ), */
                  ),
                  // Espaço entre o cartaz e as informações
                  const SizedBox(height: 16), // Adicionado para criar espaço
                  // Nome do evento
                  Text(
                    widget.event.nome,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Data e hora do evento
                  Text(
                    "Data e Hora: ${widget.event.data} ",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Localização do evento
                  Text(
                    "Localização: ${widget.event.local}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Status do evento
                  Text(
                    "Status: ${widget.event.status}",
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Descrição
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
                  const SizedBox(
                      height:
                          60), // Espaço aumentado para mover o botão mais para cima
                ],
              ),
            ),
          ),
          // Botão de Check-in posicionado no canto inferior direito
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 100, right: 16.0), // Ajuste para elevar o botão
              child: ElevatedButton(
                onPressed: () => _createFictitiousCheckIn(widget.event.id),
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
