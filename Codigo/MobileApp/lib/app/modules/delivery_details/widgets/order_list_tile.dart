import 'package:delivery_manager/app/data/models/order.dart';
import 'package:flutter/material.dart';

class OrderListTile extends ListTile {
  final Order order;

  OrderListTile({Key? key, required this.order})
      : super(
            key: key,
            title: Text(
              order.buyerName,
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.orderProducts
                  .map(
                    (orderProduct) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          orderProduct.name.length > 30
                              ? orderProduct.name.substring(0, 30) + '...'
                              : orderProduct.name,
                        ),
                        Text('${orderProduct.quantity}x'),
                      ],
                    ),
                  )
                  .toList(),
            ));
}
