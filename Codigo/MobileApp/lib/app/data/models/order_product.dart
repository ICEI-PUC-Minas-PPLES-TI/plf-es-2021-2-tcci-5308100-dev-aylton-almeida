import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_product.freezed.dart';
part 'order_product.g.dart';

@Freezed()
class OrderProduct with _$OrderProduct {
  const factory OrderProduct({
    required int orderProductId,
    required int productSku,
    required String name,
    required int quantity,
    required String variant,
  }) = _OrderProduct;

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);
}
