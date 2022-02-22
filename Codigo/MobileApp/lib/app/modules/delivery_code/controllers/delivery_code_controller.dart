import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_args.dart';
import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_state.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';

class DeliveryCodeController extends GetxController {
  late GlobalKey<FormState> codeFormKey;

  late TextEditingController codeController;

  final isLoading = false.obs;
  final isValid = false.obs;

  DeliveryCodeController({GlobalKey<FormState>? codeFormKey})
      : codeFormKey = codeFormKey ?? GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();

    codeController = TextEditingController();
  }

  @override
  void onClose() {
    codeController.dispose();

    super.onClose();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'digite o código de entrega'.tr.capitalizeFirst!;
    } else if ((value.length != 6) || int.tryParse(value) == null) {
      return 'código de entrega inválido'.tr.capitalizeFirst!;
    }
    return null;
  }

  void handleFormChange() {
    isValid.value = codeFormKey.currentState!.validate();
  }

  Future<void> submitForm() async {
    // TODO: test

    isLoading.value = true;
    dismissKeyboard(Get.overlayContext!);

    if (codeFormKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 1));

      Get.toNamed(
        Routes.PHONE_INPUT,
        arguments: PhoneInputArgs(state: PhoneInputState.deliverer),
      );
    } else {
      Get.find<AppController>()
          .showAlert(text: 'Código de entrega inválido', type: AlertType.error);
    }

    isLoading.value = false;
  }
}
