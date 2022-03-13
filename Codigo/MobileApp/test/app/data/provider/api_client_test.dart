import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_client_test.mocks.dart';

@GenerateMocks([Client, StorageRepository])
void main() {
  group('Testing Api Client', () {
    // Mock
    late MockClient mockClient;
    late MockStorageRepository mockStorageRepository;

    setUp(() {
      mockClient = MockClient();
      mockStorageRepository = MockStorageRepository();
    });

    tearDown(() {
      reset(mockClient);
      reset(mockStorageRepository);
    });

    test('Get headers', () async {
      // when
      final repository = ApiClient(
        httpClient: mockClient,
        storageRepository: mockStorageRepository,
      );
      const authToken = 'auth token';
      const expectedHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken'
      };

      // mock
      when(mockStorageRepository.getAuthToken())
          .thenAnswer((_) async => authToken);

      // then
      final response = await repository.getHeaders();

      // assert
      expect(response, equals(expectedHeaders));
      verify(mockStorageRepository.getAuthToken()).called(1);
    });

    test('Handle Api response when success', () {
      // when
      final repository = ApiClient(
        httpClient: mockClient,
        storageRepository: mockStorageRepository,
      );
      final requestResponse = Response('{"message": "success"}', 200);

      // then
      final response = repository.handleApiResponse(requestResponse);

      // assert
      expect(response, equals({'message': 'success'}));
    });

    test('Handle Api response an exception is thrown', () async {
      // when
      final repository = ApiClient(
        httpClient: mockClient,
        storageRepository: mockStorageRepository,
      );
      final requestResponse = Response('{"message": "error"}', 400);

      // assert
      expect(
        () => repository.handleApiResponse(requestResponse),
        throwsA(isA<Exception>()),
      );
    });
  });
}
