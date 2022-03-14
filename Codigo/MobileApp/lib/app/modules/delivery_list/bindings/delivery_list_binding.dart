import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/delivery_list_controller.dart';

class DeliveryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryListController>(
      () => DeliveryListController(
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
