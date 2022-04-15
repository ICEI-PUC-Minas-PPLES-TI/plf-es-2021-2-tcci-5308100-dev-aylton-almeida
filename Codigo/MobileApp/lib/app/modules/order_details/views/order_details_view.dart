import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/product_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
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
        titleText: 'order_details'.tr,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recipient_name'.tr.replaceAll(
                    ':name',
                    controller.order.buyerName,
                  ),
              style: Get.textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Text(
              'delivery_address'.tr.replaceAll(
                    ':address',
                    controller.order.shippingAddress.formatted,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: LoadingButton(
                onPressed: controller.onConfirmTap,
                child: Text('confirm_delivery'.tr),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.onRegisterProblemTap,
                child: Text('register_problem'.tr),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text('products_list'.tr, style: Get.textTheme.headline6),
            const SizedBox(height: 24),
            for (var product in controller.order.orderProducts)
              Column(
                children: [
                  ProductListTile(
                    orderProduct: product,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  const Divider()
                ],
              )
          ],
        ),
      ),
    );
  }
}
