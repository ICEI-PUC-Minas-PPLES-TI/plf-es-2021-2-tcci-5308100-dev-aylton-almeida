import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/delivery_complete_controller.dart';

class DeliveryCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryCompleteController>(
      () => DeliveryCompleteController(
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
