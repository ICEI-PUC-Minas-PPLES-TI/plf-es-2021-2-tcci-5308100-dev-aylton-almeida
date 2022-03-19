// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

enum DeliveryStatus {
  created,
  in_progress,
  finished,
}

extension DeliveryStatusExtension on DeliveryStatus {
  String get value => describeEnum(this);
}
