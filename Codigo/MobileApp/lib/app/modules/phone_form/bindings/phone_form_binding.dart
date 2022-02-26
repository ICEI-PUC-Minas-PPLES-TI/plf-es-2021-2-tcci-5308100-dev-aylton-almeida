import 'package:get/get.dart';

import '../controllers/phone_form_controller.dart';

class PhoneFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneFormController>(
      () => PhoneFormController(),
    );
  }
}
