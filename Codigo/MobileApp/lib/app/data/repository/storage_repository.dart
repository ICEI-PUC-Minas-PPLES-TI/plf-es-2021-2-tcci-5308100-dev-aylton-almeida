import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageRepository {
  final FlutterSecureStorage _storageClient;

  static const _authTokenKey = 'authToken';

  StorageRepository({required FlutterSecureStorage storageClient})
      : _storageClient = storageClient;

  Future<String?> getAuthToken() async {
    // TODO: test

    return await _storageClient.read(key: _authTokenKey);
  }

  Future<void> setAuthToken(String authToken) async {
    // TODO: test

    await _storageClient.write(key: _authTokenKey, value: authToken);
  }

  Future<void> deleteAuthToken() async {
    // TODO: test

    await _storageClient.delete(key: _authTokenKey);
  }
}
