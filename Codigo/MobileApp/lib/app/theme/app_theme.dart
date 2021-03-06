import 'package:delivery_manager/app/theme/app_bar_theme.dart';
import 'package:delivery_manager/app/theme/dialog_theme.dart';
import 'package:delivery_manager/app/theme/elevated_button_theme.dart';
import 'package:delivery_manager/app/theme/list_tile_theme.dart';
import 'package:delivery_manager/app/theme/outlined_button_theme.dart';
import 'package:delivery_manager/app/theme/snackbar_theme.dart';
import 'package:delivery_manager/app/theme/tab_bar_theme.dart';
import 'package:delivery_manager/app/theme/text_theme.dart';
import 'package:delivery_manager/app/utils/create_material_color.dart';
import 'package:flutter/material.dart';

final appThemeData = ThemeData(
  primarySwatch: createMaterialColor(const Color(0xFFFC5200)),
  fontFamily: 'GeneralSans',
  snackBarTheme: snackBarTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  appBarTheme: appBarTheme,
  backgroundColor: Colors.white,
  textTheme: textThemeData,
  tabBarTheme: tabBarTheme,
  listTileTheme: listTileTheme,
  dialogTheme: dialogTheme,
);
