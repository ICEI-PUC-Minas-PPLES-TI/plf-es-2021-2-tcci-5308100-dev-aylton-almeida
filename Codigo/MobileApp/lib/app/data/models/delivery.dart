import 'package:delivery_manager/app/data/enums/delivery_status.dart';

class Delivery {
  String? deliveryId;
  int? supplierId;
  String? offerId;
  DeliveryStatus? status;
  String? accessCode;
  bool? reportSent;
  DateTime? startTime;
  DateTime? endTime;

  Delivery({
    this.deliveryId,
    this.supplierId,
    this.offerId,
    this.status,
    this.accessCode,
    this.reportSent,
    this.startTime,
    this.endTime,
  });

  Delivery.fromJson(Map<String, dynamic> json) {
    deliveryId = json['deliveryId'];
    supplierId = json['supplierId'];
    offerId = json['offerId'];
    status = json['status'] != null
        ? DeliveryStatus.values.firstWhere((val) => val.value == json['status'])
        : null;
    accessCode = json['accessCode'];
    reportSent = json['reportSent'];
    startTime =
        json['startTime'] != null ? DateTime.parse(json['startTime']) : null;
    endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'deliveryId': deliveryId,
      'supplierId': supplierId,
      'offerId': offerId,
      'status': status?.value,
      'accessCode': accessCode,
      'reportSent': reportSent,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
