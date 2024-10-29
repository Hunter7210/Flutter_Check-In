import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  final String idUsu;

  const UserProfilePage({Key? key, required this.idUsu}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<User?> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo =
        _fetchUserInfo(); // Busca as informações do usuário ao inicializar
  }

  Future<User?> _fetchUserInfo() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Usuario').doc(widget.idUsu).get();
      if (doc.exists) {
        return User.fromFirestore(
            doc); // Retorna um objeto User se o documento existir
      } else {
        return null; // Retorna null se o documento não existir
      }
    } catch (e) {
      print("Erro ao buscar informações do usuário: $e");
      return null; // Retorna null em caso de erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<User?>(
        future: _userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar perfil"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Usuário não encontrado"));
          } else {
            User user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${user.name}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Telefone: ${user.phone}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Cargo: ${user.position}',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// Modelo User
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String position;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? 'Nome não disponível',
      email: data['email'] ?? 'Email não disponível',
      phone: data['phone'] ?? 'Telefone não disponível',
      position: data['position'] ?? 'Cargo não disponível',
    );
  }
}
