import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';

class DeliveryDetailsView extends GetView<DeliveryDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeliveryDetailsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(
          () => Text(
            'Current deliverer phone ${Get.find<AuthController>().deliverer.value.phone ?? ''}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
