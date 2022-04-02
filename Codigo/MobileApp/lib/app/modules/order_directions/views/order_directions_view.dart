import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_directions_controller.dart';

class OrderDirectionsView extends GetView<OrderDirectionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderDirectionsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderDirectionsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
