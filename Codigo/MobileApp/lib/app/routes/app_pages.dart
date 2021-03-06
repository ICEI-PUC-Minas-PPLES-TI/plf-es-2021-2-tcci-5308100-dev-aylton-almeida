import 'package:get/get.dart';

import '../modules/confirmation_code_form/bindings/confirmation_code_form_binding.dart';
import '../modules/confirmation_code_form/views/confirmation_code_form_view.dart';
import '../modules/delivery_code_form/bindings/delivery_code_form_binding.dart';
import '../modules/delivery_code_form/views/delivery_code_form_view.dart';
import '../modules/delivery_complete/bindings/delivery_complete_binding.dart';
import '../modules/delivery_complete/views/delivery_complete_view.dart';
import '../modules/delivery_details/bindings/delivery_details_binding.dart';
import '../modules/delivery_details/views/delivery_details_view.dart';
import '../modules/delivery_list/bindings/delivery_list_binding.dart';
import '../modules/delivery_list/views/delivery_list_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/order_directions/bindings/order_directions_binding.dart';
import '../modules/order_directions/views/order_directions_view.dart';
import '../modules/order_problems/bindings/order_problems_binding.dart';
import '../modules/order_problems/views/order_problems_view.dart';
import '../modules/phone_form/bindings/phone_form_binding.dart';
import '../modules/phone_form/views/phone_form_view.dart';
import '../modules/supplier_account/bindings/supplier_account_binding.dart';
import '../modules/supplier_account/views/supplier_account_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.DELIVERY_CODE_FORM,
      page: () => DeliveryCodeFormView(),
      binding: DeliveryCodeFormBinding(),
    ),
    GetPage(
      name: _Paths.PHONE_FORM,
      page: () => PhoneFormView(),
      binding: PhoneFormBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_DETAILS,
      page: () => DeliveryDetailsView(),
      binding: DeliveryDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRMATION_CODE_FORM,
      page: () => ConfirmationCodeFormView(),
      binding: ConfirmationCodeFormBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER_ACCOUNT,
      page: () => SupplierAccountView(),
      binding: SupplierAccountBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_LIST,
      page: () => DeliveryListView(),
      binding: DeliveryListBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DIRECTIONS,
      page: () => OrderDirectionsView(),
      binding: OrderDirectionsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_PROBLEMS,
      page: () => OrderProblemsView(),
      binding: OrderProblemsBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_COMPLETE,
      page: () => DeliveryCompleteView(),
      binding: DeliveryCompleteBinding(),
    ),
  ];
}
