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
      body: const Center(
        child: Text(
          'DeliveryDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
