import 'package:delivery_manager/app/data/provider/api_client.dart';

class AuthRepository {
  final basePath = '/auth';
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  dynamic getCurrentUser(String userToken) {
    // TODO: implement
  }
}
