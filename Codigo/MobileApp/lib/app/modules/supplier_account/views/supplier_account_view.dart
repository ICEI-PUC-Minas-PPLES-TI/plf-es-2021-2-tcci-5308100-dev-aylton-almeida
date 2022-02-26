import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/supplier_account_controller.dart';

class SupplierAccountView extends GetView<SupplierAccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SupplierAccountView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SupplierAccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
