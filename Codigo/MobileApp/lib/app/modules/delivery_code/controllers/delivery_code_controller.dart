import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:get/get.dart';

class DeliveryCodeController extends GetxController {
  //TODO: Implement DeliveryCodeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void handleButtonPressed() => Get.find<AppController>().showAlert(
        text: 'This is a success alert',
        type: AlertType.success,
      );
}
