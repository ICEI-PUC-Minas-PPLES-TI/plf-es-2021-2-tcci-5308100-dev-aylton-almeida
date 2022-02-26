import 'package:get/get.dart';

import '../controllers/supplier_account_controller.dart';

class SupplierAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupplierAccountController>(
      () => SupplierAccountController(),
    );
  }
}
