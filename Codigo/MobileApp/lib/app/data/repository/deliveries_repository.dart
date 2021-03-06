import 'package:delivery_manager/app/data/enums/problem_type.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';

class DeliveriesRepository {
  static const _basePath = '/deliveries';
  final ApiClient _apiClient;

  DeliveriesRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<String> verifyDelivery(String accessCode) async {
    final response = await _apiClient.get('$_basePath/verify/$accessCode');

    return response['deliveryId'];
  }

  Future<List<Delivery>> getSupplierDeliveries() async {
    final response = await _apiClient.get(_basePath);

    return (response['deliveries'] as List<dynamic>)
        .map((delivery) => Delivery.fromJson(delivery))
        .toList();
  }

  Future<Delivery> getDelivery(String deliveryId) async {
    final response = await _apiClient.get('$_basePath/$deliveryId');

    if (response['route'] != null) {
      response['delivery']['route'] = response['route'];
    }

    return Delivery.fromJson(response['delivery']);
  }

  Future<void> startDelivery(String deliveryId) async {
    await _apiClient.post('$_basePath/$deliveryId');
  }

  Future<void> deliverOrder({
    required String deliveryId,
    required String orderId,
    ProblemType? problemType,
    String? problemDescription,
  }) async {
    await _apiClient.put('$_basePath/deliver-order', body: {
      'deliveryId': deliveryId,
      'orderId': orderId,
      if (problemType != null)
        'problem': {
          'type': problemType.value,
          if (problemDescription != null) 'description': problemDescription,
        }
    });
  }
}
