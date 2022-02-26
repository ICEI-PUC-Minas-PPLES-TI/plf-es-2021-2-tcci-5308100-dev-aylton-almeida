import 'package:flutter/material.dart';

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    side: const BorderSide(color: Color(0xFFFC5200)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
  ),
);
