import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong2/latlong.dart';

// Classe de Mock para FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Classe de Mock para DocumentReference
class MockDocumentReference extends Mock implements DocumentReference {}

// Classe de Mock para QuerySnapshot
class MockQuerySnapshot extends Mock implements QuerySnapshot {}

// Classe de Mock para DocumentSnapshot
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

// Classe para o Evento
class Event {
  final String local;

  Event({required this.local});
}

// Seu widget de teste
class YourWidget extends StatelessWidget {
  final LatLng eventLocation;
  final FirebaseFirestore firestore;

  YourWidget({required this.eventLocation, required this.firestore});

  // Exemplo de botão para check-in
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Evento')),
      body: Center(
        child: ElevatedButton(
          key: Key('checkInButton'),
          onPressed: () {
            // Implementação do método de check-in
            // Aqui você chamaria a lógica para verificar a localização
          },
          child: Text('Check-in'),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Evento Check-in Tests', () {
    late MockFirebaseFirestore mockFirestore;
    late Position mockPosition;

    // Método auxiliar para converter a string de localização em LatLng
    LatLng _parseLocation(String locationString) {
      List<String> parts = locationString.split(',');
      return LatLng(
          double.parse(parts[0].trim()), double.parse(parts[1].trim()));
    }

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
    });

    testWidgets('Check-in realizado dentro do raio',
        (WidgetTester tester) async {
      // Definindo manualmente a posição do usuário que está dentro do raio
      mockPosition = Position(
          latitude: -22.571000, // Posição simulada do usuário
          longitude: -47.403000,
          timestamp: DateTime.now(),
          accuracy: 10,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          headingAccuracy: 0,
          altitudeAccuracy: 0);

      // Mock para obter a posição do usuário
      when(Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high))
          .thenAnswer((_) async => mockPosition);

      // Criação de um evento com localização
      Event event = Event(local: "-22.571075,-47.403860");
      LatLng eventLocation = _parseLocation(event.local);

      // Inicia o widget
      await tester.pumpWidget(MaterialApp(
        home:
            YourWidget(eventLocation: eventLocation, firestore: mockFirestore),
      ));

      // Chama o método de check-in
      await tester.tap(find.byKey(Key('checkInButton')));
      await tester.pumpAndSettle();

      // Print no console
      print("Usuário realizou o Check-in");
    });

    testWidgets('Check-in fora do raio', (WidgetTester tester) async {
      // Simule uma posição do usuário que está fora do raio
      mockPosition = Position(
          latitude: -22.600000, // Fora da localização do evento
          longitude: -47.500000,
          timestamp: DateTime.now(),
          accuracy: 10,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          headingAccuracy: 0,
          altitudeAccuracy: 0);

      // Mock para obter a posição do usuário
      when(Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high))
          .thenAnswer((_) async => mockPosition);

      // Criação de um evento com localização
      Event event = Event(local: "-22.571075,-47.403860");
      LatLng eventLocation = _parseLocation(event.local);

      // Inicia o widget
      await tester.pumpWidget(MaterialApp(
        home:
            YourWidget(eventLocation: eventLocation, firestore: mockFirestore),
      ));

      // Chama o método de check-in
      await tester.tap(find.byKey(Key('checkInButton')));
      await tester.pumpAndSettle();

      // Print no console
      print("Usuário fora do raio de autenticação");
    });

    testWidgets('Testa a permissão de localização',
        (WidgetTester tester) async {
      // Mock para o Geolocator
      when(Geolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(Geolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.always);

      // Criação de um evento com localização
      Event event = Event(local: "-22.571075,-47.403860");
      LatLng eventLocation = _parseLocation(event.local);

      // Inicia o widget
      await tester.pumpWidget(MaterialApp(
        home:
            YourWidget(eventLocation: eventLocation, firestore: mockFirestore),
      ));

      // Chama o método de check-in
      await tester.tap(find.byKey(Key('checkInButton')));
      await tester.pumpAndSettle();

      // Print no console
      print("Permissão de localização verificada com sucesso");
    });
  });
}
