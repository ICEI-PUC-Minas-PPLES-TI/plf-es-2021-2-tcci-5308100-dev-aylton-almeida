import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/theme/app_theme.dart';
import 'package:delivery_manager/app/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future main() async {
  // Load env variables
  await dotenv.load();

  // Add initialization logic here
  FlutterNativeSplash.removeAfter(
    (BuildContext _) async => Get.find<AuthController>().getCurrentUser(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void initializeControllers() {
    final storageRepository = StorageRepository(
      storageClient: const FlutterSecureStorage(),
    );

    Get.lazyPut(() => AppController());
    Get.lazyPut(
      () => AuthController(
        authRepository: AuthRepository(
          apiClient: ApiClient(
            httpClient: Client(),
            storageRepository: storageRepository,
          ),
        ),
        storageRepository: storageRepository,
      ),
    );
    Get.lazyPut(() => storageRepository);
  }

  @override
  Widget build(BuildContext context) {
    initializeControllers();

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
