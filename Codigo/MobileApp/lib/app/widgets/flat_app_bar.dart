import 'package:flutter/material.dart';

class FlatAppBar extends AppBar {
  FlatAppBar({
    Key? key,
    required Widget title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTile = true,
  }) : super(
          key: key,
          title: title,
          bottom: PreferredSize(
            child: Container(color: Colors.grey[50], height: 1),
            preferredSize: const Size.fromHeight(1),
          ),
          centerTitle: centerTile,
          leading: leading,
          actions: actions,
        );
}
