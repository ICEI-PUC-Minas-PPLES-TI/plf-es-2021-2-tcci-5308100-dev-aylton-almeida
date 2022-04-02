import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryDetailsHeader extends StatelessWidget {
  DeliveryDetailsHeader({
    Key? key,
    required this.delivery,
    required User currentUser,
    required this.onShareTap,
    required this.onStartTap,
    required this.onCancelTap,
  })  : showDeliveryDate = currentUser == User.supplier,
        showEstimateTime = currentUser == User.deliverer,
        showShareButton = currentUser == User.supplier &&
            delivery.status == DeliveryStatus.created,
        showStartButton = currentUser == User.deliverer,
        super(key: key);

  final Delivery delivery;
  final void Function()? onShareTap;
  final void Function()? onStartTap;
  final void Function()? onCancelTap;

  final bool showDeliveryDate; // TODO: test
  final bool showEstimateTime; // TODO: test
  final bool showShareButton; // TODO: test
  final bool showStartButton; // TODO: test

  Widget getEstimateTime() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'delivery_estimate_time'
              .tr
              .replaceAll(
                ':hour',
                delivery.route!.estimateTime.split(':')[0],
              )
              .replaceAll(
                ':minute',
                delivery.route!.estimateTime.split(':')[1],
              ),
        ),
      ],
    );
  }

  Widget getDeliveryDate() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'delivery_${delivery.status!.value}_subtitle'
              .tr
              .replaceAll(':day', delivery.deliveryDate!.day.toString())
              .replaceAll(':hour', delivery.deliveryDate!.hour.toString()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(delivery.name!, style: Get.textTheme.headline5),
          if (showDeliveryDate) getDeliveryDate(),
          const SizedBox(height: 16),
          Text(
            'delivery_initial_address'.tr.replaceAll(
                  ':address',
                  delivery.orders![0].shippingAddress.formatted,
                ),
          ),
          if (showEstimateTime) getEstimateTime(),
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
          if (showShareButton)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onShareTap,
                  child: Text('share_delivery_with_deliverer'.tr),
                ),
              ],
            ),
          if (showStartButton)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onStartTap,
                  child: Text('start_delivery'.tr),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onCancelTap,
                  child: Text('cancel_delivery'.tr),
                ),
              ],
            )
        ],
      ),
    );
  }
}
