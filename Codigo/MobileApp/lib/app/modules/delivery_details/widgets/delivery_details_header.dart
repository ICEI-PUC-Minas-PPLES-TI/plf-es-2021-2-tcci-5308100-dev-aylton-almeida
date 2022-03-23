import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryDetailsHeader extends StatelessWidget {
  const DeliveryDetailsHeader({
    Key? key,
    required this.delivery,
    required this.onShareTap,
    required this.showShareBtn,
  }) : super(key: key);

  final Delivery delivery;
  final void Function() onShareTap;
  final bool showShareBtn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(delivery.name!, style: Get.textTheme.headline5),
          const SizedBox(height: 8),
          Text(
            'delivery_${delivery.status!.value}_subtitle'
                .tr
                .replaceAll(':day', delivery.deliveryDate!.day.toString())
                .replaceAll(':hour', delivery.deliveryDate!.hour.toString()),
          ),
          const SizedBox(height: 16),
          Text(
            'delivery_initial_address'.tr.replaceAll(
                  ':address',
                  delivery.orders![0].shippingAddress.formatted,
                ),
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
          if (showShareBtn)
            Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onShareTap,
                    child: Text('share_delivery_with_deliverer'.tr),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
