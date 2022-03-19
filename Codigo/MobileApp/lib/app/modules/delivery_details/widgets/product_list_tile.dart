import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:flutter/material.dart';

class ProductListTile extends ListTile {
  final OrderProduct orderProduct;

  ProductListTile({Key? key, required this.orderProduct})
      : super(
          key: key,
          title: Text(orderProduct.name),
          trailing: Text('${orderProduct.quantity}x'),
        );
}
