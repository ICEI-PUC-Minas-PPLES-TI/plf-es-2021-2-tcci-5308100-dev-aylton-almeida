import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/confirmation_code_form_controller.dart';

class ConfirmationCodeFormView extends GetView<ConfirmationCodeFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConfirmationCodeFormView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ConfirmationCodeFormView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
