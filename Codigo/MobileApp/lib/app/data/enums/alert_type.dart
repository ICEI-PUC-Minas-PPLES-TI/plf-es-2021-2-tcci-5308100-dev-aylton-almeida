import 'package:flutter/material.dart';

enum AlertType {
  success,
  error,
  warning,
  info,
}

extension AlertTypeColor on AlertType {
  Color get color {
    switch (this) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }
}
