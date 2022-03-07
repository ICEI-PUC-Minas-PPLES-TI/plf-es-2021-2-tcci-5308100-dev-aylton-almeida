import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@Freezed()
class Supplier with _$Supplier {
  const factory Supplier({
    int? supplierId,
    String? phone,
    String? name,
    String? legalId,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
