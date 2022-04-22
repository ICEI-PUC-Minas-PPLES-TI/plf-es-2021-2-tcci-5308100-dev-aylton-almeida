import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_complete_controller.dart';

class DeliveryCompleteView extends GetView<DeliveryCompleteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/hang_loose.png', height: 120),
                      const SizedBox(height: 8),
                      Text(
                        'delivery_complete_header'.tr,
                        style: Get.textTheme.headline4,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'delivery_complete_subheader'.tr,
                        style: Get.textTheme.subtitle2,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox(height: 16)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('go_back_button'),
                      onPressed: controller.onGoToStartTap,
                      child: Text('go_back_to_start'.tr),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
