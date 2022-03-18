import 'package:delivery_manager/app/widgets/keyboard_dismiss_container.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/flat_app_bar.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:delivery_manager/app/widgets/scrollable_form.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/confirmation_code_form_controller.dart';

class ConfirmationCodeFormView extends GetView<ConfirmationCodeFormController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissContainer(
      child: Scaffold(
        appBar: FlatAppBar(
          leading: IconButton(
            onPressed: controller.goBack,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          ),
          title: Image.asset('assets/images/small_logo.png', height: 30),
        ),
        body: ScrollableForm(
          key: controller.codeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'confirmation_code_form_header'.tr,
                  style: Get.textTheme.headline6,
                ),
                const SizedBox(height: 16),
                Text(
                  'confirmation_code_form_sub_header'
                      .tr
                      .replaceAll(':phone', controller.currentPhone ?? ''),
                  style: Get.textTheme.subtitle2,
                ),
                const SizedBox(height: 24),
                Text(
                  'confirmation_code_input_label'.tr,
                  textAlign: TextAlign.start,
                  style: Get.textTheme.bodyText1,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => OutlinedTextField(
                    controller: controller.codeController,
                    keyboardType: TextInputType.number,
                    hintText: 'code_input_hint'.tr,
                    errorText: controller.errorMessage.value,
                    validator: controller.validator,
                    onChanged: (_) => controller.handleFormChange(),
                    maxLength: 5,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('confirmation_code_resend_button'),
                  onPressed: controller.resendCode,
                  child: Text('resend_code_button'.tr),
                ),
                TextButton(
                  key: const Key('confirmation_code_change_number_button'),
                  onPressed: controller.goBack,
                  child: Text('change_number_button'.tr),
                ),
              ],
            ),
            const Expanded(child: SizedBox(height: 16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => LoadingButton(
                    key: const Key('code_submit_button'),
                    onPressed: controller.submitForm,
                    child: Text("verify_code_button".tr),
                    isLoading: controller.isLoading.value,
                    isDisabled: !controller.isValid.value,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
