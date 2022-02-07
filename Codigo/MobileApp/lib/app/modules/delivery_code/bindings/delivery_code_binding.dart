import 'package:get/get.dart';

import '../controllers/delivery_code_controller.dart';

class DeliveryCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryCodeController>(
      () => DeliveryCodeController(),
    );
  }
}
