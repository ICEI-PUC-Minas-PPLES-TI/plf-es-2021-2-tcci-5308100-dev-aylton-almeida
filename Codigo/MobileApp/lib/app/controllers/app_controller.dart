import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  void showAlert(Widget content, {AlertType type = AlertType.info}) =>
      Get.overlayContext != null
          ? ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
              SnackBar(
                content: content,
                behavior: SnackBarBehavior.floating,
                backgroundColor: type.color,
              ),
            )
          : null;
}
