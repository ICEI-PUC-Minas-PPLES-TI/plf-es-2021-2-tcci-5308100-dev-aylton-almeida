import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'storage_repository_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  group('Testing Storage Repository', () {
    // Mock
    late MockFlutterSecureStorage mockStorageClient;

    createStorageRepository({
      MockFlutterSecureStorage? storageClient,
    }) {
      return StorageRepository(
        storageClient: storageClient ?? MockFlutterSecureStorage(),
      );
    }

    setUp(() {
      mockStorageClient = MockFlutterSecureStorage();
    });

    tearDown(() {
      reset(mockStorageClient);
    });

    test('Get auth token', () async {
      // when
      final repository = createStorageRepository(
        storageClient: mockStorageClient,
      );
      const key = 'authToken';
      const token = 'token';

      // mock
      when(mockStorageClient.read(key: key)).thenAnswer((_) async => token);

      // then
      final response = await repository.getAuthToken();

      // assert
      expect(response, equals(token));
      verify(mockStorageClient.read(key: key)).called(1);
    });

    test('Set auth token', () async {
      // when
      final repository = createStorageRepository(
        storageClient: mockStorageClient,
      );
      const key = 'authToken';
      const token = 'token';

      // mock
      when(mockStorageClient.write(key: key, value: token))
          .thenAnswer((_) async => {});

      // then
      await repository.setAuthToken(token);

      // assert
      verify(mockStorageClient.write(key: key, value: token)).called(1);
    });

    test('Delete auth token', () async {
      // when
      final repository = createStorageRepository(
        storageClient: mockStorageClient,
      );
      const key = 'authToken';

      // mock
      when(mockStorageClient.delete(key: key)).thenAnswer((_) async => {});

      // then
      await repository.deleteAuthToken();

      // assert
      verify(mockStorageClient.delete(key: key)).called(1);
    });
  });
}
