import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:get/get.dart';

class SupplierAccountController extends GetxController {
  final AuthController _authController;

  SupplierAccountController({required AuthController authController})
      : _authController = authController;

  Supplier get supplier => _authController.supplier.value!;
}
