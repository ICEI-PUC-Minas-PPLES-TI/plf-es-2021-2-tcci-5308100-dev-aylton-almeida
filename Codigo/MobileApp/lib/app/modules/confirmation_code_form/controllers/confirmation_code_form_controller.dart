import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationCodeFormController extends GetxController {
  late GlobalKey<FormState> codeFormKey;
  late TextEditingController codeController;

  final isLoading = false.obs;
  final isValid = false.obs;

  ConfirmationCodeFormController({GlobalKey<FormState>? codeFormKey})
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
}
