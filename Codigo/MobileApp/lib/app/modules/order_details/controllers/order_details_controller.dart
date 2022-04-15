import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/modules/order_details/arguments/order_details_args.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final AppController _appController;

  final Order _order;

  OrderDetailsController({
    required AppController appController,
    Order? order,
  })  : _order = (Get.arguments as OrderDetailsArgs?)?.order ?? order!,
        _appController = appController,
        super();

  Order get order => _order;

  void onConfirmTap() {
    // TODO: implement
  }

  void onRegisterProblemTap() {
    // TODO: go to register problem screen
  }

  void goBack() => Get.back();
}
