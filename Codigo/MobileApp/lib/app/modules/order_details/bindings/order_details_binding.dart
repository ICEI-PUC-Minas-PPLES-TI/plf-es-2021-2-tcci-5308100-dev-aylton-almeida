import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsController>(
      () => OrderDetailsController(
        appController: Get.find<AppController>(),
      ),
    );
  }
}
