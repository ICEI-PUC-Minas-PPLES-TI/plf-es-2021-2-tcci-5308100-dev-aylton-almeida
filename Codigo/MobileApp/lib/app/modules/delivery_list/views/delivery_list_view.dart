import 'package:delivery_manager/app/modules/delivery_list/widgets/delivery_list.dart';
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
          tabs: controller.tabs.toList(),
        ),
        userName: controller.supplier.name,
      ),
      body: TabBarView(
        controller: controller.tabsController,
        children: controller.tabs
            .map(
              (item) => Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final currentDeliveries =
                      controller.getCurrentDelivery(item.key!);

                  if (currentDeliveries.isEmpty) {
                    return Center(
                        child: Text('delivery_list_no_deliveries'.tr));
                  }

                  return DeliveryList(
                    onRefreshList: () =>
                        controller.fetchDeliveries(wasForced: true),
                    deliveries: currentDeliveries,
                    onTileTap: (deliveryId) {},
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
