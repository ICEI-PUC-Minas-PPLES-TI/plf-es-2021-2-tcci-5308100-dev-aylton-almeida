import 'package:delivery_manager/app/data/models/directions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing Directions model', () {
    test('Create directions from map', () {
      // when
      final directions = {
        'routes': [
          {
            'legs': [
              {
                'distance': {
                  'text': '1.2 km',
                  'value': 1234,
                },
                'duration': {
                  'text': '1 min',
                  'value': 12,
                },
              },
            ],
            'overview_polyline': {'points': ''}
          },
        ],
      };

      // then
      final response = Directions.fromMap(directions);

      // assert
      expect(response.totalDistance, '1.2 km');
      expect(response.totalDuration, '1 min');
    });
  });
}
