import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery.freezed.dart';
part 'delivery.g.dart';

@Freezed()
class Delivery with _$Delivery {
  const factory Delivery({
    String? deliveryId,
    int? supplierId,
    String? offerId,
    DeliveryStatus? status,
    String? accessCode,
    bool? reportSent,
    DateTime? startTime,
    DateTime? endTime,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);
}
