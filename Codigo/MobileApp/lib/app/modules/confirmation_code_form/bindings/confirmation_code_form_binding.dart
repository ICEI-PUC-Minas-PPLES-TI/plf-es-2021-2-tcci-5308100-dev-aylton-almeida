import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/confirmation_code_form_controller.dart';

class ConfirmationCodeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmationCodeFormController>(
      () => ConfirmationCodeFormController(
        appController: Get.find<AppController>(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
