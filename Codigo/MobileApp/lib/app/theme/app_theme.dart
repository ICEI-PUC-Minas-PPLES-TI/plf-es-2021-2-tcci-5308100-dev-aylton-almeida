import 'package:delivery_manager/app/theme/app_bar_theme.dart';
import 'package:delivery_manager/app/theme/elevated_button_theme.dart';
import 'package:delivery_manager/app/theme/snackbar_theme.dart';
import 'package:delivery_manager/app/theme/text_theme.dart';
import 'package:delivery_manager/utils/create_material_color.dart';
import 'package:flutter/material.dart';

final appThemeData = ThemeData(
  primarySwatch: createMaterialColor(const Color(0xFFFC5200)),
  fontFamily: 'GeneralSans',
  snackBarTheme: snackBarTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  appBarTheme: appBarTheme,
  backgroundColor: Colors.white,
  textTheme: textThemeData,
);
