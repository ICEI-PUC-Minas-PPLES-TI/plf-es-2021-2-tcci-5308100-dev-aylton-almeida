import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/supplier_account_controller.dart';

class SupplierAccountView extends GetView<SupplierAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SupplierAccountView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          controller.supplier.name,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
