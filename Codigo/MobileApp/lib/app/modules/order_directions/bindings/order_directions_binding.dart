import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/position_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../controllers/order_directions_controller.dart';

class OrderDirectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDirectionsController>(
      () => OrderDirectionsController(
        deliveriesRepository: DeliveriesRepository(
          apiClient: ApiClient(
            httpClient: Client(),
            storageRepository: Get.find<StorageRepository>(),
          ),
        ),
        locationRepository: Get.find<PositionRepository>(),
        authController: Get.find<AuthController>(),
        appController: Get.find<AppController>(),
      ),
    );
  }
}
