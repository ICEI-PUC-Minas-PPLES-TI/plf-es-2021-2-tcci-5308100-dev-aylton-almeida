import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/models/deliverer.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'auth_controller_test.mocks.dart';

@GenerateMocks([AuthRepository, StorageRepository])
void main() {
  group('Testing Auth Controller', () {
    // Mock
    late MockAuthRepository mockAuthRepository;
    late MockStorageRepository mockStorageRepository;

    createAuthController({
      MockAuthRepository? authRepository,
      MockStorageRepository? storageRepository,
    }) {
      return AuthController(
        authRepository: authRepository ?? MockAuthRepository(),
        storageRepository: storageRepository ?? MockStorageRepository(),
      );
    }

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockStorageRepository = MockStorageRepository();
    });

    tearDown(() {
      reset(mockAuthRepository);
      reset(mockStorageRepository);
    });

    test('Authenticate deliverer', () async {
      // when
      final controller = createAuthController(
        authRepository: mockAuthRepository,
        storageRepository: mockStorageRepository,
      );
      const phone = 'valid phone';
      const delivererId = 1;
      const deliveryId = 'delivery id';
      const token = 'token';
      const deliverer = Deliverer(
        delivererId: delivererId,
        phone: phone,
        deliveryId: deliveryId,
      );

      // mock
      when(mockAuthRepository.authDeliverer(phone, deliveryId))
          .thenAnswer((_) async => const Tuple2(deliverer, token));
      when(mockStorageRepository.setAuthToken(token)).thenAnswer((_) async {});

      // then
      await controller.authenticateDeliverer(phone, deliveryId);

      // assert
      expect(controller.deliverer.value, equals(deliverer));
      verify(mockAuthRepository.authDeliverer(phone, deliveryId)).called(1);
      verify(mockStorageRepository.setAuthToken(token)).called(1);
    });

    test('Authenticate supplier', () async {
      // when
      final controller = createAuthController(
        authRepository: mockAuthRepository,
        storageRepository: mockStorageRepository,
      );
      const phone = 'valid phone';
      const supplierId = 1;
      const token = 'token';

      // mock
      when(mockAuthRepository.authSupplier(phone))
          .thenAnswer((_) async => supplierId);

      // then
      await controller.authenticateSupplier(phone);

      // assert
      expect(controller.supplierId, equals(supplierId));
      verify(mockAuthRepository.authSupplier(phone)).called(1);
    });

    test('Verify supplier auth code', () async {
      // when
      final controller = createAuthController(
        authRepository: mockAuthRepository,
        storageRepository: mockStorageRepository,
      );
      const code = 'valid code';
      const supplierId = 1;
      const token = 'token';
      const supplier = Supplier(
        supplierId: supplierId,
        phone: 'phone',
        name: 'name',
        legalId: 'legalId',
      );

      // mock
      controller.supplierId = supplierId;
      when(mockAuthRepository.verifySupplierAuthCode(supplierId, code))
          .thenAnswer((_) async => const Tuple2(supplier, token));
      when(mockStorageRepository.setAuthToken(token)).thenAnswer((_) async {});

      // then
      await controller.verifySupplierAuthCode(code);

      // assert
      expect(controller.supplier.value, equals(supplier));
      verify(mockAuthRepository.verifySupplierAuthCode(supplierId, code))
          .called(1);
      verify(mockStorageRepository.setAuthToken(token)).called(1);
    });
  });
}
