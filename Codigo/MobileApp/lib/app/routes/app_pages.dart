import 'package:get/get.dart';

import 'package:delivery_manager/app/modules/delivery_code/bindings/delivery_code_binding.dart';
import 'package:delivery_manager/app/modules/delivery_code/views/delivery_code_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.DELIVERY_CODE,
      page: () => DeliveryCodeView(),
      binding: DeliveryCodeBinding(),
    ),
  ];
}
