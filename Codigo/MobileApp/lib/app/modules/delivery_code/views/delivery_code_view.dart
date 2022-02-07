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
          onPressed: controller.handleButtonPressed,
          child: const Text('Show an alert'),
        ),
      ),
    );
  }
}
