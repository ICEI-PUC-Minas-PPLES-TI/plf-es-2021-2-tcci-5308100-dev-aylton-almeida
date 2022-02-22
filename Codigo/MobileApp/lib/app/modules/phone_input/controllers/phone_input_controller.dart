import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_args.dart';
import 'package:delivery_manager/app/modules/phone_input/arguments/phone_input_state.dart';
import 'package:delivery_manager/app/utils/create_phone_mask.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInputController extends GetxController {
  late GlobalKey<FormState> phoneFormKey;
  late TextEditingController phoneController;
  late MaskTextInputFormatter phoneMask;

  final isLoading = false.obs;
  final isValid = false.obs;

  late Map<String, dynamic> currentAssets;

  PhoneInputController({GlobalKey<FormState>? phoneFormKey}) {
    this.phoneFormKey = phoneFormKey ?? GlobalKey<FormState>();

    currentAssets =
        (Get.arguments as PhoneInputArgs).state == PhoneInputState.deliverer
            ? {
                'title': 'antes de acessar a rote'.tr.capitalizeFirst,
                'btn': 'ver detalhes da entrega'.tr.capitalizeFirst
              }
            : {
                'title': 'parceiro, acesse sua conta'.tr.capitalizeFirst,
                'btn': 'receber código por WhatsApp'.tr.capitalizeFirst
              };
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
    dismissKeyboard(Get.overlayContext!);

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;
  }

  void goBack() => Get.back();
}
