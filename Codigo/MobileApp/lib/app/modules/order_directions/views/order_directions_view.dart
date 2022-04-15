import 'package:delivery_manager/app/modules/order_directions/widgets/order_details_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/order_directions_controller.dart';

class OrderDirectionsView extends GetView<OrderDirectionsController> {
  @override
  Widget build(BuildContext context) {
    final height = Get.mediaQuery.size.height;
    final width = Get.mediaQuery.size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    GoogleMap(
                      myLocationEnabled: true,
                      compassEnabled: true,
                      zoomControlsEnabled: false,
                      tiltGesturesEnabled: true,
                      onMapCreated: controller.onMapCreated,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition!,
                        zoom: controller.defaultZoom,
                      ),
                      polylines: {
                        if (controller.directions != null)
                          Polyline(
                            polylineId: const PolylineId('direction_polyline'),
                            color: Get.theme.primaryColor,
                            width: 5,
                            points: controller.directions!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          ),
                      },
                      markers: controller.markers,
                      onTap: controller.areOrderDetailsOpen
                          ? (_) => controller.onOrderCardTap()
                          : null,
                    ),
                    Positioned(
                      bottom: height * 0.02,
                      left: width * 0.05,
                      child: OrderDetailsCard(
                        isOpen: controller.areOrderDetailsOpen,
                        order: controller.currentOrder!,
                        estimateTime: controller.directions!.totalDuration,
                        onOpenTap: controller.onOrderCardTap,
                        onDetailsTap: controller.onOrderDetailsTap,
                      ),
                    )
                  ],
                ),
                floatingActionButton: Obx(
                  () => AnimatedScale(
                    scale: controller.showFab ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: FloatingActionButton(
                      onPressed: controller.centerCurrentLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
