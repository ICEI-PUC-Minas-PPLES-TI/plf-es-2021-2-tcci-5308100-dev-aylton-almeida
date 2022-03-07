import 'package:freezed_annotation/freezed_annotation.dart';

part 'deliverer.freezed.dart';
part 'deliverer.g.dart';

@Freezed()
class Deliverer with _$Deliverer {
  const factory Deliverer({
    int? delivererId,
    String? phone,
    String? deliveryId,
  }) = _Deliverer;

  factory Deliverer.fromJson(Map<String, dynamic> json) =>
      _$DelivererFromJson(json);
}
