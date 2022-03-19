import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/arguments/delivery_details_args.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DeliveryDetailsController extends GetxController {
  final DeliveriesRepository _deliveriesRepository;
  final AppController _appController;
  final AuthController _authController;

  final String _deliveryId;

  final isLoading = false.obs;
  final Rx<Delivery?> _delivery = Rx(null);

  DeliveryDetailsController({
    required DeliveriesRepository deliveriesRepository,
    required AppController appController,
    required AuthController authController,
    String? deliveryId,
  })  : _deliveryId =
            (Get.arguments as DeliveryDetailsArgs?)?.deliveryId ?? deliveryId!,
        _appController = appController,
        _authController = authController,
        _deliveriesRepository = deliveriesRepository;

  Supplier? get supplier => _authController.supplier.value;

  Delivery? get delivery => _delivery.value;

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
      _delivery.value = await _deliveriesRepository.getDelivery(_deliveryId);
    } catch (e) {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    } finally {
      isLoading.value = false;
    }
  }

  void shareWithDeliverer() => Share.share(
        'share_with_deliverer'
            .tr
            .replaceAll(':name', _delivery.value!.name!)
            .replaceAll(':code', _delivery.value!.accessCode!),
      );

  void goBack() => Get.back();
}
