import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryList extends StatelessWidget {
  final Future<void> Function() onRefreshList;
  final List<Delivery> deliveries;
  final void Function(String deliveryId) onTileTap;

  const DeliveryList({
    Key? key,
    required this.onRefreshList,
    required this.deliveries,
    required this.onTileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefreshList,
      child: ListView.separated(
        itemCount: deliveries.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  delivery.name!,
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  'delivery_subtitle'
                      .tr
                      .replaceAll(':day', delivery.deliveryDate!.day.toString())
                      .replaceAll(
                          ':hour', delivery.deliveryDate!.hour.toString()),
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(Icons.arrow_back_ios_new),
                ),
                onTap: () => onTileTap(delivery.deliveryId!),
              ),
            ],
          );
        },
      ),
    );
  }
}
