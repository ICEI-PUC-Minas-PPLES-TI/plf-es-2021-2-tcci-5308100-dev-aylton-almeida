import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/order_directions_controller.dart';

class OrderDirectionsView extends GetView<OrderDirectionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => controller.currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.currentPosition!,
                zoom: 15.0,
              ),
            ),
    ));
  }
}
