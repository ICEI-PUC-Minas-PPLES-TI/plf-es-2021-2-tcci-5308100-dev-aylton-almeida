import 'package:delivery_manager/app/data/models/deliverer.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;

  Rx<Deliverer?> deliverer = Rx(null);
  Rx<Supplier?> supplier = Rx(null);

  int? supplierId;

  AuthController({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository;

  Future<void> authenticateDeliverer(String phone, String deliveryId) async {
    final response = await _authRepository.authDeliverer(phone, deliveryId);

    await _storageRepository.setAuthToken(response.item2);

    deliverer.value = response.item1;
  }

  Future<void> authenticateSupplier(String phone) async {
    supplierId = await _authRepository.authSupplier(phone);
  }

  Future<void> verifySupplierAuthCode(String code) async {
    final response =
        await _authRepository.verifySupplierAuthCode(supplierId!, code);

    await _storageRepository.setAuthToken(response.item2);

    supplier.value = response.item1;
  }

  Future<void> signOut() async {
    await _storageRepository.deleteAuthToken();

    deliverer.value = null;
    supplier.value = null;

    Get.offAllNamed(Routes.DELIVERY_CODE_FORM);
  }

  Future<void> getCurrentUser() async {
    try {
      final response = await _authRepository.authorizeUser();

      if (response.item1 == null && response.item2 == null) {
        Get.offAllNamed(Routes.DELIVERY_CODE_FORM);
      } else if (response.item1 != null) {
        deliverer.value = response.item1!;
        Get.offAllNamed(Routes.DELIVERY_DETAILS);
      } else if (response.item2 != null) {
        supplier.value = response.item2!;
        Get.offAllNamed(Routes.DELIVERY_LIST);
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
