import 'package:get/get.dart';

import '../controllers/phone_input_controller.dart';

class PhoneInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhoneInputController>(
      () => PhoneInputController(),
    );
  }
}
