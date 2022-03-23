import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@Freezed()
class Address with _$Address {
  const Address._();

  const factory Address({
    required int addressId,
    required String cityName,
    required String countryState,
    required String streetName,
    required String streetNumber,
    required String? unitNumber,
    required String postalCode,
    required String neighborhoodName,
    required double lat,
    required double lng,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  String get formatted =>
      '$streetName, $streetNumber${unitNumber != null ? '/$unitNumber' : ''} - $neighborhoodName, $cityName - $countryState';
}
