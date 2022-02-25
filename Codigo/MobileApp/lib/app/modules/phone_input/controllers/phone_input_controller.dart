import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_args.dart';
import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_state.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/create_phone_mask.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInputController extends GetxController {
  // TODO: test

  late GlobalKey<FormState> phoneFormKey;
  late TextEditingController phoneController;
  late MaskTextInputFormatter phoneMask;
  late PhoneInputArgs? args;
  late Map<String, dynamic> currentAssets;

  final isLoading = false.obs;
  final isValid = false.obs;

  PhoneInputController({
    GlobalKey<FormState>? phoneFormKey,
    PhoneInputArgs? args,
  }) {
    this.phoneFormKey = phoneFormKey ?? GlobalKey<FormState>();
    this.args = (Get.arguments as PhoneInputArgs?) ?? args;

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
    currentAssets = args?.state == PhoneInputState.deliverer
        ? {
            'title': 'antes de acessar a rote'.tr.capitalizeFirst,
            'btn': 'ver detalhes da entrega'.tr.capitalizeFirst
          }
        : {
            'title': 'parceiro, acesse sua conta'.tr.capitalizeFirst,
            'btn': 'receber código por WhatsApp'.tr.capitalizeFirst
          };
  }

  String? validator(String? value) {
    final pureValue = phoneMask.getUnmaskedText();

    if (pureValue.isEmpty || pureValue.length < 13) {
      return 'insira um telefone válido'.tr;
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
