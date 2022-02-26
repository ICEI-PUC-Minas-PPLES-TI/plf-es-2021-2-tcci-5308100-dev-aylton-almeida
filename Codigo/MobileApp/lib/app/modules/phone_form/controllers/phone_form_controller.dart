import 'package:delivery_manager/app/modules/confirmation_code_form/arguments/confirmation_code_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/create_phone_mask.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneFormController extends GetxController {
  late GlobalKey<FormState> phoneFormKey;
  late TextEditingController phoneController;
  late MaskTextInputFormatter phoneMask;
  late PhoneFormUser? user;
  late Map<String, dynamic> currentAssets;

  final isLoading = false.obs;
  final isValid = false.obs;

  PhoneFormController({
    GlobalKey<FormState>? phoneFormKey,
    PhoneFormArgs? args,
  }) {
    this.phoneFormKey = phoneFormKey ?? GlobalKey<FormState>();
    user = (Get.arguments as PhoneFormArgs?)?.user ?? args?.user;

    setCurrentAssets();
  }

  @override
  void onInit() {
    super.onInit();

    phoneController = TextEditingController();
    phoneMask = createPhoneMask();
  }

  @override
  void onClose() {
    phoneController.dispose();

    super.onClose();
  }

  void setCurrentAssets() {
    currentAssets = user == PhoneFormUser.deliverer
        ? {
            'title': 'phone_form_deliverer_header'.tr,
            'btn': 'phone_form_deliverer_button'.tr
          }
        : {
            'title': 'phone_form_supplier_header'.tr,
            'btn': 'phone_form_supplier_button'.tr
          };
  }

  String? validator(String? value) {
    final pureValue = phoneMask.getUnmaskedText();

    if (pureValue.isEmpty || pureValue.length < 13) {
      return 'invalid_phone_input_error'.tr;
    }

    return null;
  }

  void handleFormChange() {
    isValid.value = phoneFormKey.currentState!.validate();
  }

  Future<void> submitForm() async {
    // TODO: implement real logic

    isLoading.value = true;
    DismissKeyboard.dismiss(Get.overlayContext!);

    await Future.delayed(const Duration(seconds: 1));

    if (user == PhoneFormUser.deliverer) {
      Get.toNamed(Routes.DELIVERY_DETAILS);
    } else {
      Get.toNamed(
        Routes.CONFIRMATION_CODE_FORM,
        arguments:
            ConfirmationCodeFormArgs(currentPhone: phoneMask.getMaskedText()),
      );
    }

    isLoading.value = false;
  }

  void goBack() => Get.back();
}
