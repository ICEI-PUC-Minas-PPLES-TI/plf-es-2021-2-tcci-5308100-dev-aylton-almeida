import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/arguments/confirmation_code_form_args.dart';
import 'package:delivery_manager/app/modules/delivery_details/arguments/delivery_details_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/create_phone_mask.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneFormController extends GetxController {
  late AuthController _authController;

  late GlobalKey<FormState> phoneFormKey;
  late TextEditingController phoneController;
  late MaskTextInputFormatter phoneMask;
  late User? user;
  late String? currentDeliveryId;
  late Map<String, dynamic> currentAssets;

  final isLoading = false.obs;
  final isValid = false.obs;
  final Rx<String?> errorMessage = Rx(null);

  PhoneFormController({
    required AuthController authController,
    GlobalKey<FormState>? phoneFormKey,
    PhoneFormArgs? args,
  }) {
    this.phoneFormKey = phoneFormKey ?? GlobalKey<FormState>();
    user = (Get.arguments as PhoneFormArgs?)?.user ?? args?.user;
    currentDeliveryId =
        (Get.arguments as PhoneFormArgs?)?.deliveryId ?? args?.deliveryId;

    _authController = authController;

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
    currentAssets = user == User.deliverer
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
    if (errorMessage.value != null) {
      errorMessage.value = null;
    }
    isValid.value = phoneFormKey.currentState!.validate();
  }

  Future<void> handleDelivererSubmit(String phone) async {
    await _authController.authenticateDeliverer(phone, currentDeliveryId!);

    Get.offAllNamed(
      Routes.DELIVERY_DETAILS,
      arguments: DeliveryDetailsArgs(
        deliveryId: currentDeliveryId!,
        user: User.deliverer,
      ),
    );
  }

  Future<void> handleSupplierSubmit(String phone) async {
    try {
      await _authController.authenticateSupplier(phone);

      Get.toNamed(
        Routes.CONFIRMATION_CODE_FORM,
        arguments:
            ConfirmationCodeFormArgs(currentPhone: phoneMask.getMaskedText()),
      );
    } catch (e) {
      errorMessage.value = 'phone_not_registered_error'.tr;
    }
  }

  Future<void> submitForm() async {
    try {
      isLoading.value = true;
      DismissKeyboard.dismiss(Get.overlayContext!);

      final phone = '+${phoneMask.getUnmaskedText()}';

      if (user == User.deliverer) {
        await handleDelivererSubmit(phone);
      } else {
        await handleSupplierSubmit(phone);
      }
    } catch (e) {
      errorMessage.value = 'generic_error_msg'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() => Get.back();
}
