import 'package:flutter/material.dart';

final primarySwatch = MaterialColor(
  const Color(0xFFFC5200).value,
  const <int, Color>{
    50: Color(0xFFFC5200),
    100: Color(0xFFFC5200),
    200: Color(0xFFFC5200),
    300: Color(0xFFFC5200),
    400: Color(0xFFFC5200),
    500: Color(0xFFFC5200),
    600: Color(0xFFFC5200),
    700: Color(0xFFFC5200),
    800: Color(0xFFFC5200),
    900: Color(0xFFFC5200),
  },
);

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
  primarySwatch: primarySwatch,
  fontFamily: 'Roboto',
  snackBarTheme: snackBarTheme,
  elevatedButtonTheme: elevatedButtonTheme,
);
