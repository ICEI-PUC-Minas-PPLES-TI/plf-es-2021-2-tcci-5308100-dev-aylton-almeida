import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const appBarTheme = AppBarTheme(
  color: Colors.white,
  elevation: 0,
  titleTextStyle: TextStyle(
    color: Colors.black,
    fontSize: 20,
  ),
  systemOverlayStyle: SystemUiOverlayStyle(
    // Status bar color
    statusBarColor: Colors.white,

    // Status bar brightness (optional)
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // For iOS (dark icons)
  ),
);
