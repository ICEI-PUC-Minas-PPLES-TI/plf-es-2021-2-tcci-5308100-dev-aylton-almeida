import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';

class DeliveriesRepository {
  final _basePath = '/deliveries';
  final ApiClient _apiClient;

  DeliveriesRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<String> verifyDelivery(String accessCode) async {
    final response = await _apiClient.get('$_basePath/verify/$accessCode');

    return response['deliveryId'];
  }

  Future<List<Delivery>> getSupplierDeliveries() async {
    // TODO: test

    final response = await _apiClient.get(_basePath);

    return (response['deliveries'] as List<dynamic>)
        .map((delivery) => Delivery.fromJson(delivery))
        .toList();
  }

  Future<Delivery> getDelivery(String deliveryId) async {
    // TODO: test

    final response = await _apiClient.get('$_basePath/$deliveryId');

    return Delivery.fromJson(response);
  }
}
