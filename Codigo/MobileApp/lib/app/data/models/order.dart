import 'package:delivery_manager/app/data/models/address.dart';
import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@Freezed()
class Order with _$Order {
  const factory Order({
    required String orderId,
    required String buyerName,
    required bool delivered,
    required int shippingAddressId,
    required String deliveryId,
    required Address shippingAddress,
    required List<OrderProduct> orderProducts,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
