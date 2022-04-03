import 'package:get/get.dart';
import '../controllers/order_directions_controller.dart';

class OrderDirectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDirectionsController>(
      () => OrderDirectionsController(
          // deliveriesRepository: DeliveriesRepository(
          //   apiClient: ApiClient(
          //     httpClient: Client(),
          //     storageRepository: Get.find<StorageRepository>(),
          //   ),
          // ),
          // authController: Get.find<AuthController>(),
          // appController: Get.find<AppController>(),
          ),
    );
  }
}
