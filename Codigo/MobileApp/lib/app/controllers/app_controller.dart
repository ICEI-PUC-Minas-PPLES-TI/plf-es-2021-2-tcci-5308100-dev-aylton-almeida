import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  void showAlert({
    required String text,
    AlertType type = AlertType.info,
    EdgeInsets margin = const EdgeInsets.all(16),
  }) =>
      Get.overlayContext != null
          ? ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
              SnackBar(
                content: Text(
                  text,
                  style: TextStyle(
                    color: type.color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                backgroundColor: type.color,
                margin: margin,
              ),
            )
          : null;
}
