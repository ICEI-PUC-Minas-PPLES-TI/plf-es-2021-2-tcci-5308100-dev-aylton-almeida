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

  void showDialog({
    required Widget title,
    required String cancelText,
    required String confirmText,
    required Function() onConfirmTap,
  }) =>
      Get.dialog(
        AlertDialog(
          title: title,
          actions: [
            OutlinedButton(
              onPressed: Get.back,
              child: Text(cancelText),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onConfirmTap,
              child: Text(confirmText),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                ),
              ),
            ),
          ],
        ),
      );
}
