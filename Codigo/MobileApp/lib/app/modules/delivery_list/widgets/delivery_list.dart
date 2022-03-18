import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter/material.dart';

class DeliveryList extends StatelessWidget {
  final Future<void> Function() onRefreshList;
  final List<Delivery> deliveries;

  const DeliveryList({
    Key? key,
    required this.onRefreshList,
    required this.deliveries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefreshList,
      child: ListView.builder(
        itemCount: deliveries.length,
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          // TODO: implement List Tiles
          return ListTile(
            title: Text(delivery.name!),
            trailing: Text(delivery.deliveryDate.toString()),
          );
        },
      ),
    );
  }
}
