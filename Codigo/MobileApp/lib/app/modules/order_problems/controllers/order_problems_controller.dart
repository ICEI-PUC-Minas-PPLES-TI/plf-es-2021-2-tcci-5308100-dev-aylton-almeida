import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/enums/problem_type.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/order_directions/controllers/order_directions_controller.dart';
import 'package:delivery_manager/app/modules/order_problems/arguments/order_problems_args.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProblemsController extends GetxController {
  final AppController _appController;
  final DeliveriesRepository _deliveriesRepository;

  late GlobalKey<FormState> formKey;
  late TextEditingController descriptionController;

  final Order _order;
  final problemTypes = [
    DropdownMenuItem(
      child: Text('absent_receiver'.tr),
      value: ProblemType.absent_receiver,
    ),
    DropdownMenuItem(
      child: Text('missing_product'.tr),
      value: ProblemType.missing_product,
    ),
  ];

  final _isLoading = false.obs;
  final _problemType = Rx<ProblemType?>(null);

  OrderProblemsController({
    required AppController appController,
    required DeliveriesRepository deliveriesRepository,
    GlobalKey<FormState>? formKey,
    Order? order,
  })  : formKey = formKey ?? GlobalKey<FormState>(),
        _order = (Get.arguments as OrderProblemsArgs?)?.order ?? order!,
        _appController = appController,
        _deliveriesRepository = deliveriesRepository,
        super();

  @override
  void onInit() {
    super.onInit();

    descriptionController = TextEditingController();
  }

  @override
  void onClose() {
    descriptionController.dispose();

    super.onClose();
  }

  Order get order => _order;

  bool get isLoading => _isLoading.value;

  bool get isValid => !isLoading && _problemType.value != null;

  ProblemType? get problemType => _problemType.value;

  Future<void> submitProblem() async {
    try {
      _isLoading.value = true;
      DismissKeyboard.dismiss(Get.overlayContext!);

      await _deliveriesRepository.deliverOrder(
        deliveryId: order.deliveryId,
        orderId: order.orderId,
        problemType: _problemType.value,
        problemDescription: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
      );

      await Get.find<OrderDirectionsController>().refreshDirections();

      _appController.showAlert(
          text: 'problem_registered'.tr, type: AlertType.warning);

      Get.until((route) => Get.currentRoute == Routes.ORDER_DIRECTIONS);
    } catch (e) {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    } finally {
      _isLoading.value = false;
    }
  }

  void handleTypeChange(ProblemType? problemType) {
    _problemType.value = problemType;
  }

  void goBack() => Get.back();
}
