import 'package:delivery_manager/app/modules/delivery_details/widgets/delivery_details_header.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/order_list_tile.dart';
import 'package:delivery_manager/app/widgets/product_list_tile.dart';
import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';

class DeliveryDetailsView extends GetView<DeliveryDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value || controller.delivery == null
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AuthenticatedAppBar(
                leading: controller.showBackButton
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                        onPressed: controller.goBack,
                      )
                    : null,
                titleText: 'delivery_details'.tr,
                userName: controller.supplier?.name,
              ),
              body: Obx(
                () {
                  if (controller.isLoading.value ||
                      controller.delivery == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final delivery = controller.delivery!;

                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Obx(
                            () => DeliveryDetailsHeader(
                              delivery: delivery,
                              currentUser: controller.currentUser,
                              onShareTap: controller.onShareTap,
                              onStartTap: controller.onStartTap,
                              onCancelTap: controller.onCancelTap,
                              isStartLoading: controller.isStartLoading.value,
                            ),
                          ),
                        ),
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverAppBar(
                            toolbarHeight: 0,
                            pinned: true,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                              controller: controller.tabsController,
                              tabs: controller.tabs.toList(),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: controller.tabsController,
                      children: controller.tabs.map(
                        (currentTab) {
                          final data = controller.getTabData(currentTab.key!);

                          return SafeArea(
                            top: false,
                            bottom: false,
                            child: Builder(
                              builder: (context) => CustomScrollView(
                                slivers: [
                                  SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                      context,
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) =>
                                            Column(
                                          children: [
                                            if (currentTab.key ==
                                                const Key('orders'))
                                              OrderListTile(order: data[index]),
                                            if (currentTab.key ==
                                                const Key('products'))
                                              ProductListTile(
                                                  orderProduct: data[index]),
                                            if (index != (data.length - 1))
                                              const Divider(),
                                          ],
                                        ),
                                        childCount: data.length,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
