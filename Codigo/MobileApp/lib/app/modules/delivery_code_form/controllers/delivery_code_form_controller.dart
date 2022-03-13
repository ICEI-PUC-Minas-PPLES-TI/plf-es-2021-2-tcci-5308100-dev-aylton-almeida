import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';

class DeliveryCodeFormController extends GetxController {
  final AppController _appController;
  final DeliveriesRepository _deliveriesRepository;

  late GlobalKey<FormState> codeFormKey;
  late TextEditingController codeController;

  final isLoading = false.obs;
  final isValid = false.obs;

  DeliveryCodeFormController({
    required AppController appController,
    required DeliveriesRepository deliveriesRepository,
    GlobalKey<FormState>? codeFormKey,
  })  : codeFormKey = codeFormKey ?? GlobalKey<FormState>(),
        _appController = appController,
        _deliveriesRepository = deliveriesRepository;

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
      return 'empty_delivery_code_input_error'.tr;
    } else if ((value.length != 6)) {
      return 'invalid_delivery_code_input_error'.tr;
    }
    return null;
  }

  void handleFormChange() {
    isValid.value = codeFormKey.currentState!.validate();
  }

  Future<void> submitForm() async {
    try {
      isLoading.value = true;
      DismissKeyboard.dismiss(Get.overlayContext!);

      final deliveryId = await _deliveriesRepository.verifyDelivery(
        codeController.text,
      );

      Get.toNamed(
        Routes.PHONE_FORM,
        arguments: PhoneFormArgs(
          user: PhoneFormUser.deliverer,
          deliveryId: deliveryId,
        ),
      );
    } catch (e) {
      _appController.showAlert(
          text: 'invalid_delivery_code_error'.tr, type: AlertType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void onSupplierPressed() {
    Get.toNamed(
      Routes.PHONE_FORM,
      arguments: PhoneFormArgs(user: PhoneFormUser.supplier),
    );
  }
}
