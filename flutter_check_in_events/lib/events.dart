import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_in_events/events_list.dart';

class MyEventsPage extends StatefulWidget {
  final Event event;

  const MyEventsPage({super.key, required this.event});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
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
        'LocalizacaoAtualCheck': '123',
        'idUsu': '2YYY0ow09jfmM79LlaC3zMdh0142',
      };

      // Adiciona um novo documento com os dados fictícios na subcoleção Check-in
      await _firestore
          .collection('Evento')
          .doc(eventId)
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
      appBar:
          AppBar(title: Text(widget.event.nome)), // Título com o nome do evento
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do evento
            Text(
              'Nome do Evento: ${widget.event.nome}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Data do Evento: ${widget.event.data}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Descrição: ${widget.event.data ?? "Descrição não disponível"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Botão de Check-In
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _createFictitiousCheckIn(widget.event.id),
              child: _isLoading
                  ? const CircularProgressIndicator() // Exibe um indicador de carregamento
                  : const Text("Check-In"),
            ),
          ],
        ),
      ),
    );
  }
}
