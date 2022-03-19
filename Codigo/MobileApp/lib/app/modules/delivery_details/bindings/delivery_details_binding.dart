import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../controllers/delivery_details_controller.dart';

class DeliveryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryDetailsController>(
      () => DeliveryDetailsController(
        deliveriesRepository: DeliveriesRepository(
          apiClient: ApiClient(
            httpClient: Client(),
            storageRepository: Get.find<StorageRepository>(),
          ),
        ),
        appController: Get.find<AppController>(),
      ),
    );
  }
}
