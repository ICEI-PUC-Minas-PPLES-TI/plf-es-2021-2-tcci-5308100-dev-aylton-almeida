import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget createTestMaterialWidget(Widget child) {
  return GetMaterialApp(
    home: Scaffold(body: child),
  );
}
