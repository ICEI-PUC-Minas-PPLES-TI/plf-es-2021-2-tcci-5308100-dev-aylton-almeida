import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/phone_form_controller.dart';

class PhoneFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneFormController>(
      () => PhoneFormController(
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
