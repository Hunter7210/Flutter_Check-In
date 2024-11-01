/* import 'package:flutter_check_in_events/events_details.dart';
import 'package:flutter_check_in_events/events_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockGeolocator extends Mock implements Geolocator {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockGeolocator mockGeolocator;
  late MyEventDetailsScreen myEventDetailsScreen;

  setUp(() {
    mockGeolocator = MockGeolocator();
    myEventDetailsScreen = MyEventDetailsScreen(
      /* Criando evento para test */
      event: Event(
          id: 'test_event',
          nome: 'Churrasco na casa do Diogo',
          local: '-22.763464608620783, -47.41555236496127',
          data: "18/12/2024 23:00",
          descricao:
              'Diogo promete um menu com carnes de primeira, acompanhamentos deliciosos, e aquela cerveja gelada que não pode faltar. Traga sua boa energia, seu apetite e algo para compartilhar! Se puder, contribua com uma bebida ou um petisco. Confirme presença para nos ajudarmos na organização.',
          status: "Ativo",
          idadMinima: 18,
          image:
              "https://imgs.search.brave.com/S1x-tLSTSjB5kl0vtKlcrADlYoGOE2yzWxxHQt36994/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzBkLzMw/LzA1LzBkMzAwNWNl/N2U1ZWUxZjk5MWQ2/OTNmOTMzZDM5YTAz/LmpwZw"), // Exemplo de coordenadas

      partiId: 'user_123',
    );
  });

  group('GeoLocation Tests', () {
    test('Check-in success when user is within range', () async {
      // Configura uma posição simulada próxima ao evento
      when(mockGeolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high))
          .thenAnswer((_) async => Position(
              latitude: 40.748800,
              longitude: -73.985400,
              timestamp: DateTime.now()));

      // Configurações adicionais para verificar o comportamento esperado no método
      await myEventDetailsScreen._getUserLocationAndCheckIn();

      // Verifique se o estado foi alterado para _isInRange como true
      expect(myEventDetailsScreen.isInRange, true);
      // Aqui você pode verificar a presença da mensagem de check-in bem-sucedido
    });

    test('Check-in denied if location permissions are denied', () async {
      // Simula permissão de localização negada
      when(mockGeolocator.checkPermission())
          .thenAnswer((_) async => LocationPermission.denied);

      bool permissionGranted =
          await myEventDetailsScreen._checkLocationPermissions();

      // Verifique se a função retorna false e a mensagem correta é exibida
      expect(permissionGranted, false);
    });

    test('Check-in shows warning if user is out of range', () async {
      // Configura uma posição simulada longe do evento
      when(mockGeolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high))
          .thenAnswer((_) async => Position(
              latitude: 40.748900,
              longitude: -73.990000,
              timestamp: DateTime.now()));

      await myEventDetailsScreen._getUserLocationAndCheckIn();

      // Verifique se o estado de _isInRange é false, indicando que o usuário está fora do alcance
      expect(myEventDetailsScreen.isInRange, false);
      // Verifique a presença da mensagem para se aproximar
    });
  });
}
 */