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
  late PhoneFormArgs? args;
  late Map<String, dynamic> currentAssets;

  final isLoading = false.obs;
  final isValid = false.obs;

  PhoneFormController({
    GlobalKey<FormState>? phoneFormKey,
    PhoneFormArgs? args,
  }) {
    this.phoneFormKey = phoneFormKey ?? GlobalKey<FormState>();
    this.args = (Get.arguments as PhoneFormArgs?) ?? args;

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
    currentAssets = args?.user == PhoneFormUser.deliverer
        ? {
            'title': 'phone_form_deliverer_header'.tr,
            'btn': 'phone_form_supplier_header'.tr
          }
        : {
            'title': 'phone_form_supplier_sub_header'.tr,
            'btn': 'receive_code_button'.tr
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
    isLoading.value = true;
    DismissKeyboard.dismiss(Get.overlayContext!);

    await Future.delayed(const Duration(seconds: 1));

    Get.toNamed(Routes.DELIVERY_DETAILS);

    isLoading.value = false;
  }

  void goBack() => Get.back();
}
