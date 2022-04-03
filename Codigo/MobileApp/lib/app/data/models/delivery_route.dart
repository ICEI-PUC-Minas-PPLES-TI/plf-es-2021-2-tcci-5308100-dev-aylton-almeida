import 'package:delivery_manager/app/data/models/route_address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_route.freezed.dart';
part 'delivery_route.g.dart';

@Freezed()
class DeliveryRoute with _$DeliveryRoute {
  const factory DeliveryRoute({
    required int deliveryRouteId,
    required String deliveryId,
    required String estimateTime,
    required List<RouteAddress> addresses,
  }) = _DeliveryRoute;

  factory DeliveryRoute.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRouteFromJson(json);
}
