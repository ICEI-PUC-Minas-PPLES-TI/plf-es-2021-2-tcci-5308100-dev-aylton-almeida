import 'package:delivery_manager/app/data/models/deliverer.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'deliveries_repository_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  group('Testing Auth Repository', () {
    // Mock
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
    });

    tearDown(() {
      reset(mockApiClient);
    });

    test('Auth Deliverer', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const phone = 'valid-phone';
      const delivererId = 1;
      const deliveryId = '456';
      const token = 'token';
      const expectedResponse = {
        'deliverer': {
          'phone': phone,
          'delivererId': delivererId,
          'deliveryId': deliveryId
        },
        'token': token
      };

      // mock
      when(
        mockApiClient.post('/auth/deliverers', body: {
          'phone': phone,
          'deliveryId': deliveryId,
        }),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.authDeliverer(phone, deliveryId);

      // assert
      expect(
        response.item1,
        equals(
          Deliverer.fromJson(
            expectedResponse['deliverer'] as Map<String, dynamic>,
          ),
        ),
      );
      expect(response.item2, equals(token));
      verify(mockApiClient.post('/auth/deliverers', body: {
        'phone': phone,
        'deliveryId': deliveryId,
      })).called(1);
    });

    test('Auth Supplier', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const phone = 'valid-phone';
      const supplierId = 1;
      const expectedResponse = {'supplierId': supplierId};

      // mock
      when(
        mockApiClient.post('/auth/suppliers', body: {
          'phone': phone,
        }),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.authSupplier(phone);

      // assert
      expect(response, equals(supplierId));
      verify(mockApiClient.post('/auth/suppliers', body: {
        'phone': phone,
      })).called(1);
    });

    test('Verify Supplier Auth Code', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const phone = 'valid-phone';
      const supplierId = 1;
      const code = 'valid-code';
      const token = 'token';
      const expectedResponse = {
        'supplier': {
          'phone': phone,
          'supplierId': supplierId,
          'name': 'valid-name',
          'legalId': 'legal-id'
        },
        'token': token
      };

      // mock
      when(
        mockApiClient.post('/auth/suppliers/verify-code', body: {
          'supplierId': supplierId,
          "code": code,
        }),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response =
          await repository.verifySupplierAuthCode(supplierId, code);

      // assert
      expect(
        response.item1,
        equals(
          Supplier.fromJson(
            expectedResponse['supplier'] as Map<String, dynamic>,
          ),
        ),
      );
      expect(response.item2, equals(token));
      verify(mockApiClient.post('/auth/suppliers/verify-code', body: {
        'supplierId': supplierId,
        "code": code,
      })).called(1);
    });

    test('Authorize user when on only deliverer', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const expectedResponse = {
        'deliverer': {
          'phone': 'valid phone',
          'delivererId': 1,
          'deliveryId': 'valid deliveryId'
        },
      };

      // mock
      when(
        mockApiClient.get('/auth'),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.authorizeUser();

      // assert
      expect(
        response.item1,
        equals(
          Deliverer.fromJson(
            expectedResponse['deliverer'] as Map<String, dynamic>,
          ),
        ),
      );
      expect(response.item2, isNull);
      verify(mockApiClient.get('/auth')).called(1);
    });

    test('Authorize user when on only supplier', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const expectedResponse = {
        'supplier': {
          'phone': 'valid phone',
          'supplierId': 1,
          'name': 'valid-name',
          'legalId': 'legal-id'
        },
      };

      // mock
      when(
        mockApiClient.get('/auth'),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.authorizeUser();

      // assert
      expect(
        response.item2,
        equals(
          Supplier.fromJson(
            expectedResponse['supplier'] as Map<String, dynamic>,
          ),
        ),
      );
      expect(response.item1, isNull);
      verify(mockApiClient.get('/auth')).called(1);
    });

    test('Authorize user when both deliverer and supplier', () async {
      // when
      final repository = AuthRepository(apiClient: mockApiClient);
      const expectedResponse = {
        'deliverer': {
          'phone': 'valid phone',
          'delivererId': 1,
          'deliveryId': 'valid deliveryId'
        },
        'supplier': {
          'phone': 'valid phone',
          'supplierId': 1,
          'name': 'valid-name',
          'legalId': 'legal-id'
        },
      };

      // mock
      when(
        mockApiClient.get('/auth'),
      ).thenAnswer((_) async => expectedResponse);

      // then
      final response = await repository.authorizeUser();

      // assert
      expect(
        response.item1,
        equals(
          Deliverer.fromJson(
            expectedResponse['deliverer'] as Map<String, dynamic>,
          ),
        ),
      );
      expect(
        response.item2,
        equals(
          Supplier.fromJson(
            expectedResponse['supplier'] as Map<String, dynamic>,
          ),
        ),
      );
      verify(mockApiClient.get('/auth')).called(1);
    });
  });
}
