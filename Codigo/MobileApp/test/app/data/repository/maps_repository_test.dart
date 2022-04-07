import 'dart:convert';

import 'package:delivery_manager/app/data/models/directions.dart';
import 'package:delivery_manager/app/data/repository/maps_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'maps_repository_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('Testing Maps Repository', () {
    // Mock
    const mapsKey = 'test_key';

    late MockClient mockClient;

    setUp(() async {
      mockClient = MockClient();
      dotenv.testLoad(fileInput: 'MAPS_API_KEY=$mapsKey');
    });

    tearDown(() {
      reset(mockClient);
    });

    test('Get directions when status 200', () async {
      // when
      const origin = LatLng(123, 456);
      const destination = LatLng(456, 789);
      final repository = MapsRepository(client: mockClient);
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/directions/json',
        {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': mapsKey,
        },
      );
      final expected_response = Response(
        json.encode({
          'routes': [
            {
              'legs': [
                {
                  'distance': {'text': '1.2 km'},
                  'duration': {'text': '1 min'},
                },
              ],
              'overview_polyline': {'points': ''}
            },
          ],
        }),
        200,
      );

      // mock
      when(mockClient.get(uri)).thenAnswer((_) async => expected_response);

      // then
      final response = await repository.getDirections(
        origin: origin,
        destination: destination,
      );

      // assert
      expect(response, isInstanceOf<Directions>());
      expect(response!.totalDistance, equals('1.2 km'));
      expect(response.totalDuration, equals('1 min'));
      verify(mockClient.get(uri)).called(1);
    });
  });
}
