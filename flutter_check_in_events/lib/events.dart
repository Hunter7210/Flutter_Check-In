import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyEventsPage extends StatefulWidget {
  final String idEvent;

  const MyEventsPage({required this.idEvent});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false; // Adiciona um estado de loading

  Future<void> _updateCheckInStatus(String eventId, String checkInId) async {
    setState(() {
      _isLoading = true; // Ativa o loading
    });

    try {
      // Atualiza o campo StatusCheck para "Registrado"
      await _firestore
          .collection('Eventos')
          .doc(eventId)
          .collection('Check-in')
          .doc(checkInId)
          .update({
        'StatusCheck': 'Registrado',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check-in registrado com sucesso!")),
      );
    } catch (e) {
      print("Erro ao atualizar o Check-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao registrar check-in.")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Desativa o loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exemplo de ID de check-in. Você deve substituir por um ID real.
    String exampleCheckInId = 'ID_DO_CHECK_IN'; // Substitua por um ID real

    return Column(
      children: [
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () => _updateCheckInStatus(widget.idEvent, exampleCheckInId),
          child: _isLoading
              ? const CircularProgressIndicator() // Exibe um indicador de carregamento
              : const Text("Check-In"),
        ),
      ],
    );
  }
}
