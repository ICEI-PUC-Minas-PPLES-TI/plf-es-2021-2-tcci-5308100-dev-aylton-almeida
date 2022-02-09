import 'package:delivery_manager/app/widgets/keyboard_dismiss_container.dart';
import 'package:delivery_manager/app/widgets/logo_app_bar.dart';
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
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
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
                          TextFormField(
                            controller: controller.codeController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'código'.tr.capitalize!,
                            ),
                            validator: controller.validator,
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(height: 8)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: controller.enableButton.value
                                ? controller.submitForm
                                : null,
                            child: Text(
                              "verificar código de entrega".tr.capitalizeFirst!,
                            ),
                          ),
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
