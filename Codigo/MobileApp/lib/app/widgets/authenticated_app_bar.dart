import 'package:delivery_manager/app/widgets/user_icon.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({
    Key? key,
    required String titleText,
    List<Widget>? actions,
    Widget? leading,
    PreferredSizeWidget? bottom,
    String? userName,
  }) : super(
          key: key,
          title: Text(
            titleText,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
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
