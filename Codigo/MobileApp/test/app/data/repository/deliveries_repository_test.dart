import 'package:delivery_manager/app/data/enums/problem_type.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
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

    test('Get Supplier deliveries', () async {
      // when
      final repository = DeliveriesRepository(apiClient: mockApiClient);
      const expectedResponse = {
        'deliveries': [
          {'deliveryId': '123'},
          {'deliveryId': '456'},
          {'deliveryId': '789'},
        ]
      };

      // mock
      when(mockApiClient.get('/deliveries'))
          .thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.getSupplierDeliveries();

      // assert
      expect(
          response,
          equals([
            for (final data in expectedResponse['deliveries']!)
              Delivery.fromJson(data),
          ]));
      verify(mockApiClient.get('/deliveries')).called(1);
    });

    test('Get Delivery Details', () async {
      // when
      final repository = DeliveriesRepository(apiClient: mockApiClient);
      const deliveryId = '123';
      const expectedResponse = {
        'delivery': {'deliveryId': '123'},
      };

      // mock
      when(mockApiClient.get('/deliveries/$deliveryId'))
          .thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.getDelivery(deliveryId);

      // assert
      expect(
          response, equals(Delivery.fromJson(expectedResponse['delivery']!)));
      verify(mockApiClient.get('/deliveries/$deliveryId')).called(1);
    });

    test('Deliver Order when no problem', () async {
      // when
      final repository = DeliveriesRepository(apiClient: mockApiClient);
      const deliveryId = '123';
      const orderId = '456';

      // mock
      when(mockApiClient.put('/deliveries/deliver-order', body: {
        'deliveryId': deliveryId,
        'orderId': orderId,
      })).thenAnswer((_) async => {});

      // then
      await repository.deliverOrder(deliveryId: deliveryId, orderId: orderId);

      // assert
      verify(mockApiClient.put('/deliveries/deliver-order', body: {
        'deliveryId': deliveryId,
        'orderId': orderId,
      })).called(1);
    });

    test('Deliver Order when problem passed', () async {
      // when
      final repository = DeliveriesRepository(apiClient: mockApiClient);
      const deliveryId = '123';
      const orderId = '456';
      const problemType = ProblemType.absent_receiver;
      const problemDescription = 'There was a problem';

      // mock
      when(mockApiClient.put('/deliveries/deliver-order', body: {
        'deliveryId': deliveryId,
        'orderId': orderId,
        'problem': {
          'type': problemType.value,
          'description': problemDescription
        }
      })).thenAnswer((_) async => {});

      // then
      await repository.deliverOrder(
        deliveryId: deliveryId,
        orderId: orderId,
        problemType: problemType,
        problemDescription: problemDescription,
      );

      // assert
      verify(mockApiClient.put('/deliveries/deliver-order', body: {
        'deliveryId': deliveryId,
        'orderId': orderId,
        'problem': {
          'type': problemType.value,
          'description': problemDescription
        }
      })).called(1);
    });
  });
}
