import 'package:delivery_manager/app/widgets/user_icon.dart';
import 'package:flutter/material.dart';

class AuthenticatedAppBar extends AppBar {
  AuthenticatedAppBar({
    Key? key,
    required String titleText,
    List<Widget>? actions,
    Widget? leading,
    PreferredSizeWidget? bottom,
    String? userName,
  }) : super(
          key: key,
          title: Text(titleText),
          leading: leading,
          actions: userName == null
              ? actions
              : [
                  ...(actions ?? []),
                  UserIcon(name: userName),
                  const Padding(padding: EdgeInsets.only(right: 8))
                ],
          bottom: bottom,
        );
}
