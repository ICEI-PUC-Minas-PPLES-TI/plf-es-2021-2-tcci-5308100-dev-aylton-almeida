import 'package:flutter/cupertino.dart';

import '../../utils/dismiss_keyboard.dart';

class KeyboardDismissContainer extends StatelessWidget {
  final Widget child;

  const KeyboardDismissContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(context),
      child: child,
    );
  }
}
