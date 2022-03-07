import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:get/get.dart';

import '../controllers/phone_form_controller.dart';

class PhoneFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneFormController>(
      () => PhoneFormController(
        appController: Get.find<AppController>(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
