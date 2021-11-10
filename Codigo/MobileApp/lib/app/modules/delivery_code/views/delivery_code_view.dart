import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_code_controller.dart';

class DeliveryCodeView extends GetView<DeliveryCodeController> {
  const DeliveryCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeliveryCodeView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.find<AppController>().showAlert(
            const Text('This is a success alert'),
            type: AlertType.success,
          ),
          child: const Text('Show an alert'),
        ),
      ),
    );
  }
}
