import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      return 'Digite o código de entrega';
    } else if ((value.length != 6) || int.tryParse(value) == null) {
      return 'Código de entrega inválido';
    }
    return null;
  }

  void handleFormChange() {
    isValid.value = codeFormKey.currentState!.validate();
  }

  Future<void> submitForm() async {
    isLoading.value = true;

    if (codeFormKey.currentState!.validate()) {
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
