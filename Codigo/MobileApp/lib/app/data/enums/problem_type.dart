// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

enum ProblemType {
  missing_product,
  absent_receiver,
}

extension ProblemTypeExtension on ProblemType {
  String get value => describeEnum(this);
}
