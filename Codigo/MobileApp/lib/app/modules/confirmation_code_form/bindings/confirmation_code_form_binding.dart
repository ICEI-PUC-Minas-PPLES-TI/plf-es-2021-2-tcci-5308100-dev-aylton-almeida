import 'package:get/get.dart';

import '../controllers/confirmation_code_form_controller.dart';

class ConfirmationCodeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmationCodeFormController>(
      () => ConfirmationCodeFormController(),
    );
  }
}
