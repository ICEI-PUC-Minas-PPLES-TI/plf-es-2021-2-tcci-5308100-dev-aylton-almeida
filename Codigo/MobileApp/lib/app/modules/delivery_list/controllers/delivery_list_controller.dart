import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryListController extends GetxController
    with SingleGetTickerProviderMixin {
  final AuthController _authController;

  late TabController tabsController;

  final tabs = <Tab>[
    Tab(text: 'today_label'.tr),
    Tab(text: 'pending_label'.tr),
    Tab(text: 'delivered_label'.tr)
  ];

  DeliveryListController({
    required AuthController authController,
  }) : _authController = authController;

  @override
  void onInit() {
    super.onInit();
    tabsController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void onClose() {
    tabsController.dispose();
    super.onClose();
  }

  Supplier get supplier => _authController.supplier.value!;
}
