import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/arguments/confirmation_code_form_args.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationCodeFormController extends GetxController {
  late AppController _appController;
  late AuthController _authController;

  late GlobalKey<FormState> codeFormKey;
  late TextEditingController codeController;
  late String? currentPhone;

  final isLoading = false.obs;
  final isValid = false.obs;

  ConfirmationCodeFormController({
    required AppController appController,
    required AuthController authController,
    GlobalKey<FormState>? codeFormKey,
    ConfirmationCodeFormArgs? args,
  }) {
    this.codeFormKey = codeFormKey ?? GlobalKey<FormState>();
    currentPhone = (Get.arguments as ConfirmationCodeFormArgs?)?.currentPhone ??
        args?.currentPhone;

    _appController = appController;
    _authController = authController;
  }

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
      return 'empty_confirmation_code_input_error'.tr;
    } else if ((value.length != 5) || int.tryParse(value) == null) {
      return 'invalid_confirmation_code_input_error'.tr;
    }
    return null;
  }

  Future<void> submitForm() async {
    try {
      isLoading.value = true;
      DismissKeyboard.dismiss(Get.overlayContext!);

      await _authController.verifySupplierAuthCode(codeController.text);

      Get.offAllNamed(Routes.DELIVERY_LIST);
    } on Exception catch (e, _) {
      if (e.toString().contains('Failed request with error 401')) {
        _appController.showAlert(
            text: 'invalid_confirmation_code_error'.tr, type: AlertType.error);
      } else {
        _appController.showAlert(
            text: 'generic_error_msg'.tr, type: AlertType.error);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    // ! implement resendCode when necessary

    DismissKeyboard.dismiss(Get.overlayContext!);

    _appController.showAlert(
        text: 'resend_code_success_message'.tr, type: AlertType.success);
  }

  void handleFormChange() {
    isValid.value = codeFormKey.currentState!.validate();
  }

  void goBack() => Get.back();
}
