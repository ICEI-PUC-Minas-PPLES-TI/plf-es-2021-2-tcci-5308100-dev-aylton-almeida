import 'package:get/get.dart';

import '../controllers/delivery_code_form_controller.dart';

class DeliveryCodeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryCodeFormController>(
      () => DeliveryCodeFormController(),
    );
  }
}
