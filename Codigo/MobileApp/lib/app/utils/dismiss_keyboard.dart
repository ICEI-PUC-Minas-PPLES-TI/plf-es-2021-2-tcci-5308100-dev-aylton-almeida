import 'package:flutter/material.dart';

abstract class DismissKeyboard {
  static void dismiss(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
