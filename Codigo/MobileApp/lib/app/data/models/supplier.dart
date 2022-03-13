import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@Freezed()
class Supplier with _$Supplier {
  const factory Supplier({
    required int supplierId,
    required String phone,
    required String name,
    required String legalId,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
