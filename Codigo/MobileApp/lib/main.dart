import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/theme/app_theme.dart';
import 'package:delivery_manager/app/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.DELIVERY_CODE,
      theme: appThemeData,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      locale: const Locale('pt', 'BR'),
      translationsKeys: AppTranslation.translations,
    );
  }
}
