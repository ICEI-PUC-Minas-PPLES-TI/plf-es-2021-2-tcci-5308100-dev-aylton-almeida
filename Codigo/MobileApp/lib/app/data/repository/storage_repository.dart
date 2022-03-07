import 'package:delivery_manager/app/data/provider/storage_client.dart';

class StorageRepository {
  final StorageClient storageClient;

  StorageRepository({required this.storageClient});

  Future<String?> getAuthToken() async {
    // TODO: test

    return await storageClient.get('authToken');
  }
}
