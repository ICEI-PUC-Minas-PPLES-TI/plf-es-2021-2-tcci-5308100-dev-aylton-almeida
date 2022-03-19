import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/arguments/delivery_details_args.dart';
import 'package:get/get.dart';

class DeliveryDetailsController extends GetxController {
  final DeliveriesRepository _deliveriesRepository;
  final AppController _appController;

  final String _deliveryId;

  final isLoading = false.obs;
  final Rx<Delivery?> delivery = Rx(null);

  DeliveryDetailsController({
    required DeliveriesRepository deliveriesRepository,
    required AppController appController,
    String? deliveryId,
  })  : _deliveryId =
            (Get.arguments as DeliveryDetailsArgs?)?.deliveryId ?? deliveryId!,
        _appController = appController,
        _deliveriesRepository = deliveriesRepository;

  @override
  void onInit() {
    // TODO: test
    super.onInit();

    fetchDelivery();
  }

  Future<void> fetchDelivery() async {
    // TODO: test

    isLoading.value = true;

    try {
      delivery.value = await _deliveriesRepository.getDelivery(_deliveryId);
    } catch (e) {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    } finally {
      isLoading.value = false;
    }
  }
}
