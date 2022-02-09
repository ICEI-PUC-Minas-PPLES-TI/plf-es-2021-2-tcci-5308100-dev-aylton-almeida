import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryCodeController extends GetxController {
  final codeFormKey = GlobalKey<FormState>();

  late TextEditingController codeController;

  final isLoading = false.obs;
  final isValid = false.obs;

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
      return 'Digite o código de entrega';
    } else if ((value.length != 6) || double.tryParse(value) == null) {
      return 'Código de entrega inválido';
    }
    return null;
  }

  bool isFormValid() {
    return codeFormKey.currentState != null &&
        codeFormKey.currentState!.validate();
  }

  void handleFormChange(String _) {
    isValid.value = isFormValid();
  }

  Future<void> submitForm() async {
    isLoading.value = true;

    if (isFormValid()) {
      await Future.delayed(const Duration(seconds: 3));

      Get.find<AppController>()
          .showAlert(text: 'Código de entrega valido', type: AlertType.success);
    } else {
      Get.find<AppController>()
          .showAlert(text: 'Código de entrega inválido', type: AlertType.error);
    }

    isLoading.value = false;
  }
}
