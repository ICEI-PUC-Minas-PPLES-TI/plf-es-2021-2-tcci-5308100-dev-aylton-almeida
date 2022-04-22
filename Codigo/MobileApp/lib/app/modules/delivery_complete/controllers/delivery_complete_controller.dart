import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class DeliveryCompleteController extends GetxController {
  final AuthController _authController;

  DeliveryCompleteController({required AuthController authController})
      : _authController = authController;

  Future<void> onGoToStartTap() async {
    await _authController.signOut();
  }
}
