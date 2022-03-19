import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/delivery_details_header.dart';
import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryDetailsView extends GetView<DeliveryDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        if (controller.isLoading.value || controller.delivery == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final delivery = controller.delivery!;

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: DeliveryDetailsHeader(
                  delivery: delivery,
                  onShareTap: controller.shareWithDeliverer,
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
            children: controller.tabs
                .map(
                  (item) => SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      builder: (context) => CustomScrollView(
                        slivers: [
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context,
                            ),
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            sliver: SliverFixedExtentList(
                              itemExtent: 60.0,
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text('Item $index'),
                                  );
                                },
                                childCount: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }
}
