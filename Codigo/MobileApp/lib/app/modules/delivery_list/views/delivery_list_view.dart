import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_list_controller.dart';

class DeliveryListView extends GetView<DeliveryListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AuthenticatedAppBar(
          titleText: 'delivery_list_title'.tr,
          bottom: TabBar(
            controller: controller.tabsController,
            tabs: controller.tabs,
          ),
          userName: controller.supplier.name,
        ),
        body: TabBarView(
          controller: controller.tabsController,
          children: controller.tabs
              .map(
                (Tab tab) => Center(
                  child: Text(
                    tab.text?.toLowerCase() ?? '',
                  ),
                ),
              )
              .toList(),
        ));
  }
}
