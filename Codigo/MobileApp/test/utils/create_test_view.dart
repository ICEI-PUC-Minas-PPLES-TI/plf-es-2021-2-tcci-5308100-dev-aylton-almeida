import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class _Wrapper extends StatelessWidget {
  final Widget child;

  const _Wrapper(this.child);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: const Size(392.727, 759.272),
      context: context,
      minTextAdapt: false,
      orientation: Orientation.portrait,
    );
    return child;
  }
}

Widget createTestView(GetView child) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: GetMaterialApp(
      home: Scaffold(
        body: _Wrapper(child),
      ),
    ),
  );
}
