import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deliveries_repository_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  group('Testing Deliveries Repository', () {
    // Mock
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
    });

    tearDown(() {
      reset(mockApiClient);
    });

    test('Verify delivery', () async {
      // when
      final repository = DeliveriesRepository(apiClient: mockApiClient);
      const accessCode = 'access code';
      const expectedResponse = {'deliveryId': '123'};

      // mock
      when(mockApiClient.get('/deliveries/verify/$accessCode'))
          .thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.verifyDelivery(accessCode);

      // assert
      expect(response, equals(expectedResponse['deliveryId']));
      verify(mockApiClient.get('/deliveries/verify/$accessCode')).called(1);
    });
  });
}
