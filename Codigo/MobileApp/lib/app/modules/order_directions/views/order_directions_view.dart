import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/order_directions_controller.dart';

class OrderDirectionsView extends GetView<OrderDirectionsController> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Obx(
        () => controller.currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: controller.onMapCreated,
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
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: controller.centerCurrentLocation,
                  child: const Icon(Icons.my_location),
                ),
              ),
      ),
    );
  }
}
