import 'package:delivery_manager/app/modules/confirmation_code_form/arguments/confirmation_code_form_args.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationCodeFormController extends GetxController {
  late GlobalKey<FormState> codeFormKey;
  late TextEditingController codeController;
  late String? currentPhone;

  final isLoading = false.obs;
  final isValid = false.obs;

  ConfirmationCodeFormController({
    GlobalKey<FormState>? codeFormKey,
    ConfirmationCodeFormArgs? args,
  }) {
    this.codeFormKey = codeFormKey ?? GlobalKey<FormState>();
    currentPhone = (Get.arguments as ConfirmationCodeFormArgs?)?.currentPhone ??
        args?.currentPhone;
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
    // TODO: implement submitForm
  }

  Future<void> resendCode() async {
    // TODO: implement resendCode
  }

  void handleFormChange() {
    isValid.value = codeFormKey.currentState!.validate();
  }

  void goBack() => Get.back();
}
