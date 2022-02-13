import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';

class DeliveriesRepository {
  final basePath = '/deliveries';
  final ApiClient apiClient;

  DeliveriesRepository({required this.apiClient});

  getAll() async {
    final apiResponse = await apiClient.getAll(basePath);
    return apiResponse.map((json) => Delivery.fromJson(json));
  }
}
