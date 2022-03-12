import 'package:delivery_manager/app/data/models/deliverer.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:tuple/tuple.dart';

class AuthRepository {
  final _basePath = '/auth';
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  dynamic getCurrentUser(String userToken) {
    // TODO: implement
  }

  Future<Tuple2<Deliverer, String>> authDeliverer(
    String phone,
    String deliveryId,
  ) async {
    // TODO: test

    final response = await _apiClient.post('$_basePath/deliverers', {
      'phone': phone,
      'deliveryId': deliveryId,
    });

    return Tuple2(Deliverer.fromJson(response['deliverer']), response['token']);
  }

  Future<Tuple2<Deliverer?, Supplier?>> authorizeUser() async {
    // TODO: test

    final response = await _apiClient.get(_basePath);

    return Tuple2(
      response['deliverer'] != null
          ? Deliverer.fromJson(response['deliverer'])
          : null,
      response['supplier'] != null
          ? Supplier.fromJson(response['supplier'])
          : null,
    );
  }
}