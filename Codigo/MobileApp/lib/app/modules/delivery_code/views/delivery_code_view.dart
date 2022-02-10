import 'package:delivery_manager/app/widgets/keyboard_dismiss_container.dart';
import 'package:delivery_manager/app/widgets/logo_app_bar.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_code_controller.dart';

class DeliveryCodeView extends GetView<DeliveryCodeController> {
  const DeliveryCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissContainer(
      child: Scaffold(
        appBar: FlatAppBar(
          title: Image.asset('assets/images/small_logo.png', height: 30),
        ),
        body: Form(
          key: controller.codeFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'você possui um código?'.tr.capitalizeFirst!,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'caso não, mas deseje ver suas entregas'
                                .tr
                                .capitalizeFirst!,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'código de 6 dígitos'.tr.capitalizeFirst!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(height: 16),
                          OutlinedTextField(
                            controller: controller.codeController,
                            keyboardType: TextInputType.number,
                            hintText: 'código'.tr.capitalize!,
                            validator: controller.validator,
                            onChanged: (_) => controller.handleFormChange(),
                            maxLength: 6,
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(height: 16)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Obx(
                            () => ElevatedButton(
                              onPressed: !controller.isLoading.value &&
                                      controller.isValid.value
                                  ? controller.submitForm
                                  : null,
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "verificar código de entrega"
                                          .tr
                                          .capitalizeFirst!,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => {},
                            child: Text(
                              "sou um parceiro trela".tr.capitalizeFirst!,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
