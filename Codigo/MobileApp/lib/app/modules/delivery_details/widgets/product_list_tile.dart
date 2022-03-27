import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:flutter/material.dart';

class ProductListTile extends ListTile {
  final OrderProduct orderProduct;

  ProductListTile({Key? key, required this.orderProduct})
      : super(
          key: key,
          title: Text(orderProduct.name),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (orderProduct.variant.isNotEmpty) Text(orderProduct.variant),
              Text('${orderProduct.quantity}x')
            ],
          ),
        );
}
