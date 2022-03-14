import 'package:delivery_manager/app/utils/legal_id_parser.dart';
import 'package:delivery_manager/app/widgets/flat_app_bar.dart';
import 'package:delivery_manager/app/widgets/scrollable_form.dart';
import 'package:delivery_manager/app/widgets/user_icon.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/supplier_account_controller.dart';

class SupplierAccountView extends GetView<SupplierAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlatAppBar(
        title: Text('supplier_account_title'.tr),
        centerTile: false,
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: ScrollableForm(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserIcon(name: controller.supplier.name),
                  const SizedBox(width: 20),
                  Text(
                    controller.supplier.name,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(height: 36),
              Text('supplier_data'.tr, style: Get.textTheme.headline6),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CNPJ/CPF:'),
                  Text(formatLegalId(controller.supplier.legalId)),
                ],
              )
            ],
          ),
          const Expanded(child: SizedBox(height: 16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                onPressed: controller.exit,
                child: Text('exit_button'.tr),
              ),
            ],
          )
        ],
      ),
    );
  }
}
