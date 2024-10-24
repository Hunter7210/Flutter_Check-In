import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_check_in_events/login_user.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  bool registro = false;

  Future<void> _register() async {
    try {
      // Criar um usuário no Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Adicionar dados do usuário no Firestore
      await _firestore.collection('Usuario').doc(userCredential.user!.uid).set({
        'NomeUsu': _nomeController.text.trim(),
        'DataNascimentoUsu': _dataNascimentoController.text.trim(),
        'CPFUsu': _cpfController.text.trim(),
      });

      setState(() {
        registro =
            true; // Atualiza o estado para indicar que o registro foi bem-sucedido
      });

      print("Usuário registrado: ${userCredential.user}");

      // Navegar para a tela de login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      print("Erro ao registrar usuário: ${e.message}");
      // Aqui você pode exibir uma mensagem de erro para o usuário
    } catch (e) {
      print("Erro desconhecido: $e");
      // Aqui também pode ser útil exibir uma mensagem para o usuário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Auth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _dataNascimentoController,
              decoration:
                  const InputDecoration(labelText: "Data de Nascimento"),
            ),
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: "CPF"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
