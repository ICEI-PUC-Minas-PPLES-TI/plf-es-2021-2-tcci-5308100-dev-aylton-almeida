import 'package:get/get.dart';

import '../modules/delivery_code/bindings/delivery_code_binding.dart';
import '../modules/delivery_code/views/delivery_code_view.dart';
import '../modules/phone_input/bindings/phone_input_binding.dart';
import '../modules/phone_input/views/phone_input_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.DELIVERY_CODE,
      page: () => DeliveryCodeView(),
      binding: DeliveryCodeBinding(),
    ),
    GetPage(
      name: _Paths.PHONE_INPUT,
      page: () => PhoneInputView(),
      binding: PhoneInputBinding(),
    ),
  ];
}
