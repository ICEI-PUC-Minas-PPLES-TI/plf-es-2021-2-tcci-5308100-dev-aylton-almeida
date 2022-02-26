import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/theme/app_theme.dart';
import 'package:delivery_manager/app/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  // Load env variables
  await dotenv.load();

  // Add initialization logic here
  FlutterNativeSplash.removeAfter((BuildContext _) async => {});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppController());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.DELIVERY_CODE_FORM,
      theme: appThemeData,
      defaultTransition: Transition.fade,
      getPages: AppPages.routes,
      locale: const Locale('pt', 'BR'),
      translationsKeys: AppTranslation.translations,
    );
  }
}
