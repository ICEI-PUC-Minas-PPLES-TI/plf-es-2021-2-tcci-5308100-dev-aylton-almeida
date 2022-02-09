import 'package:delivery_manager/utils/create_material_color.dart';
import 'package:flutter/material.dart';

const snackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  ),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
  ),
);

final appThemeData = ThemeData(
  primarySwatch: createMaterialColor(const Color(0xFFFC5200)),
  fontFamily: 'GeneralSans',
  snackBarTheme: snackBarTheme,
  elevatedButtonTheme: elevatedButtonTheme,
);
