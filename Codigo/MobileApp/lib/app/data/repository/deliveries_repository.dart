import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';

class DeliveriesRepository {
  final basePath = '/deliveries';
  final ApiClient apiClient;

  DeliveriesRepository({required this.apiClient});

  Future<String?> verifyDelivery(String accessCode) async {
    final apiResponse = await apiClient.get('$basePath/verify/$accessCode');

    return Delivery.fromJson(apiResponse).deliveryId;
  }
}
