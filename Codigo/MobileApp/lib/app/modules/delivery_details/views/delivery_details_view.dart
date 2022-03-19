import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/delivery_details_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        if (controller.isLoading.value || controller.delivery == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final delivery = controller.delivery!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(delivery.name!, style: Get.textTheme.headline5),
              const SizedBox(height: 8),
              Text(
                'delivery_subtitle'
                    .tr
                    .replaceAll(':day', delivery.deliveryDate!.day.toString())
                    .replaceAll(
                        ':hour', delivery.deliveryDate!.hour.toString()),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: GoogleMap(
                    markers: {
                      Marker(
                        markerId: const MarkerId('marker'),
                        position: LatLng(
                          delivery.orders![0].shippingAddress.lat,
                          delivery.orders![0].shippingAddress.lng,
                        ),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        delivery.orders![0].shippingAddress.lat,
                        delivery.orders![0].shippingAddress.lng,
                      ),
                      zoom: 15.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.shareWithDeliverer,
                  child: Text('share_delivery_with_deliverer'.tr),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 500,
                color: Colors.green,
              )
            ],
          ),
        );
      }),
    );
  }
}
