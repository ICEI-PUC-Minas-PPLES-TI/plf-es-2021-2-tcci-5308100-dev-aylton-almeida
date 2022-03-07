import 'package:delivery_manager/app/data/models/deliverer.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;

  var deliverer = const Deliverer().obs;
  var supplier = const Supplier().obs;

  AuthController({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository;

  authenticateDeliverer(String phone, String deliveryId) async {
    final response = await _authRepository.authDeliverer(phone, deliveryId);

    await _storageRepository.setAuthToken(response.item2);

    deliverer.value = response.item1;
  }

  getCurrentUser() async {
    try {
      final response = await _authRepository.authorizeUser();

      if (response.item1 == null && response.item2 == null) {
        Get.offAllNamed(Routes.DELIVERY_CODE_FORM);
      } else if (response.item1 != null) {
        deliverer.value = response.item1!;
        Get.offAllNamed(Routes.DELIVERY_DETAILS);
      } else if (response.item2 != null) {
        supplier.value = response.item2!;
        Get.offAllNamed(Routes.SUPPLIER_ACCOUNT);
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
