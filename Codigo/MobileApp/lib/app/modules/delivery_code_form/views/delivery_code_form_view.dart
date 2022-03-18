import 'package:delivery_manager/app/widgets/keyboard_dismiss_container.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/flat_app_bar.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:delivery_manager/app/widgets/scrollable_form.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_code_form_controller.dart';

class DeliveryCodeFormView extends GetView<DeliveryCodeFormController> {
  const DeliveryCodeFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissContainer(
      child: Scaffold(
        appBar: FlatAppBar(
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
                  'delivery_code_form_header'.tr,
                  style: Get.textTheme.headline6,
                ),
                const SizedBox(height: 16),
                Text(
                  'delivery_code_form_sub_header'.tr,
                  style: Get.textTheme.subtitle2,
                ),
                const SizedBox(height: 24),
                Text(
                  'delivery_code_input_label'.tr,
                  textAlign: TextAlign.start,
                  style: Get.textTheme.bodyText1,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => OutlinedTextField(
                    controller: controller.codeController,
                    hintText: 'code_input_hint'.tr,
                    validator: controller.validator,
                    errorText: controller.errorMessage.value,
                    onChanged: (_) => controller.handleFormChange(),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                  ),
                )
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
                const SizedBox(height: 16),
                OutlinedButton(
                  key: const Key('supplier_flow_button'),
                  onPressed: controller.onSupplierPressed,
                  child: Text(
                    "trela_partner_button".tr,
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
