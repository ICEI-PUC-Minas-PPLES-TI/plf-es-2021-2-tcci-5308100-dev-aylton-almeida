import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/order_details/arguments/order_details_args.dart';
import 'package:delivery_manager/app/modules/order_directions/controllers/order_directions_controller.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final AppController _appController;
  final DeliveriesRepository _deliveriesRepository;

  final Order _order;

  final _isLoading = false.obs;

  OrderDetailsController({
    required AppController appController,
    required DeliveriesRepository deliveriesRepository,
    Order? order,
  })  : _order = (Get.arguments as OrderDetailsArgs?)?.order ?? order!,
        _appController = appController,
        _deliveriesRepository = deliveriesRepository,
        super();

  Order get order => _order;

  bool get isLoading => _isLoading.value;

  Future<void> onConfirmTap() async {
    try {
      _isLoading.value = true;

      await _deliveriesRepository.deliverOrder(
        _order.deliveryId,
        _order.orderId,
      );

      await Get.find<OrderDirectionsController>().refreshDirections();

      _appController.showAlert(
          text: 'delivery_confirmed'.tr, type: AlertType.success);

      goBack();
    } on Exception {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    } finally {
      _isLoading.value = false;
    }
  }

  void onRegisterProblemTap() {
    // TODO: go to register problem screen
  }

  void goBack() => Get.back();
}
