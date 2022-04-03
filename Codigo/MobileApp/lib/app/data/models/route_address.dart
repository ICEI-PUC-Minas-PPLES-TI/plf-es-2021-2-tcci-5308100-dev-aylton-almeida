import 'package:delivery_manager/app/data/models/address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_address.freezed.dart';
part 'route_address.g.dart';

@Freezed()
class RouteAddress with _$RouteAddress {
  const factory RouteAddress({
    required int deliveryRouteId,
    required int addressId,
    required int position,
    required Address address,
  }) = _RouteAddress;

  factory RouteAddress.fromJson(Map<String, dynamic> json) =>
      _$RouteAddressFromJson(json);
}
