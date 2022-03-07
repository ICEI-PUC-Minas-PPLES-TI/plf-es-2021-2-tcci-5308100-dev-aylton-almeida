import 'package:delivery_manager/app/data/repository/auth_repositoty.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  final StorageRepository storageRepository;

  AuthController({
    required this.authRepository,
    required this.storageRepository,
  });

  @override
  void onInit() {
    super.onInit();

    getCurrentUser();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void getCurrentUser() async {
    // TODO: finish implementation
    // final userToken = await storageRepository.getAuthToken();

    // if (userToken != null) {
    //   final user = authRepository.getCurrentUser(userToken);
    // }
  }
}
