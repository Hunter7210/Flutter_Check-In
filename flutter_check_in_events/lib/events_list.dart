import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_in_events/events.dart';

class MyListEventsPage extends StatefulWidget {
  const MyListEventsPage({super.key});

  @override
  State<MyListEventsPage> createState() => _MyListEventsPageState();
}

class _MyListEventsPageState extends State<MyListEventsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _events = _fetchEvents(); // Busca os eventos ao inicializar
  }

  Future<List<Event>> _fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Evento').get();
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(
            doc); // Cria um objeto Event a partir do documento
      }).toList();
    } catch (e) {
      print("Erro ao buscar eventos: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Eventos")),
      body: FutureBuilder<List<Event>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado."));
          }

          List<Event> events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(events[index].nome),
                subtitle: Text(events[index].data),
                onTap: () {
                  // Navegar para MyEventsPage com o objeto do evento
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEventsPage(
                        event:
                            events[index], // Passa o objeto do evento completo
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Modelo Event
class Event {
  final String id; // Adicione um campo para o ID
  final String nome;
  final String data;

  Event({required this.id, required this.nome, required this.data});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id, // Pega o ID do documento
      nome: data['NomeEvent'] ?? 'Evento sem nome',
      data: data['DataHoraEvent'] ?? 'Data não disponível',
    );
  }
}
