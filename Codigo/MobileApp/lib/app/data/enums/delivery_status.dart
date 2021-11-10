import 'package:flutter/foundation.dart';

enum DeliveryStatus {
  created,
  inProgress,
  finished,
}

extension DeliveryStatusExtension on DeliveryStatus {
  String get value => describeEnum(this);
}
