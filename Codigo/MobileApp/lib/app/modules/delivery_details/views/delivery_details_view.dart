import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';

class DeliveryDetailsView extends GetView<DeliveryDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthenticatedAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: controller.goBack,
        ),
        titleText: 'delivery_details'.tr,
        userName: controller.supplier?.name,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(child: Text(controller.delivery?.name ?? ''));
      }),
    );
  }
}
