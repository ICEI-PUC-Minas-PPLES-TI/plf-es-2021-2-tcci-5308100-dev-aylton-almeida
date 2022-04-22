import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../controllers/order_problems_controller.dart';

class OrderProblemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderProblemsController>(
      () => OrderProblemsController(
        appController: Get.find<AppController>(),
        deliveriesRepository: DeliveriesRepository(
          apiClient: ApiClient(
            httpClient: Client(),
            storageRepository: Get.find<StorageRepository>(),
          ),
        ),
      ),
    );
  }
}
