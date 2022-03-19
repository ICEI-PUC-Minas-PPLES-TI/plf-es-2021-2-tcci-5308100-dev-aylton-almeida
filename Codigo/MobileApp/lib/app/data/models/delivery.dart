import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery.freezed.dart';
part 'delivery.g.dart';

@Freezed()
class Delivery with _$Delivery {
  const factory Delivery({
    required String? deliveryId,
    required int? supplierId,
    required String? offerId,
    required String? name,
    required DeliveryStatus? status,
    required String? accessCode,
    required bool? reportSent,
    required DateTime? deliveryDate,
    required DateTime? startTime,
    required DateTime? endTime,
    required List<Order>? orders,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);
}
