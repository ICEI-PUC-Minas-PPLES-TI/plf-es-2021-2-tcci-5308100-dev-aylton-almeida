import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageClient {
  final FlutterSecureStorage storageClient;

  StorageClient({required this.storageClient});

  Future<String?> get(String key) async {
    // TODO: test

    return storageClient.read(key: key);
  }

  Future<void> set(String key, String value) async {
    // TODO: test

    await storageClient.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    // TODO: test

    await storageClient.delete(key: key);
  }
}
