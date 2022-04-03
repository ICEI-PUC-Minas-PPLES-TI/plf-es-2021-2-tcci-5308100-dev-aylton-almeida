import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/arguments/delivery_details_args.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryListController extends GetxController
    with SingleGetTickerProviderMixin {
  static const _pending = Key('pending');
  static const _inProgress = Key('in_progress');
  static const _delivered = Key('delivered');

  final DeliveriesRepository _deliveriesRepository;

  final AuthController _authController;
  final AppController _appController;

  late TabController tabsController;

  final tabs = <Tab>[
    Tab(key: _pending, text: 'pending'.tr),
    Tab(key: _inProgress, text: 'in_progress'.tr),
    Tab(key: _delivered, text: 'delivered'.tr),
  ];

  final Rx<Map<Key, List<Delivery>>> _deliveries = Rx({
    _pending: [],
    _inProgress: [],
    _delivered: [],
  });

  final isLoading = true.obs;

  DeliveryListController({
    required DeliveriesRepository deliveriesRepository,
    required AuthController authController,
    required AppController appController,
  })  : _authController = authController,
        _appController = appController,
        _deliveriesRepository = deliveriesRepository;

  @override
  void onInit() {
    super.onInit();
    tabsController = TabController(vsync: this, length: tabs.length);
    fetchDeliveries();
  }

  @override
  void onClose() {
    tabsController.dispose();
    super.onClose();
  }

  Supplier get supplier => _authController.supplier.value!;

  void onDeliveryTap(String deliveryId) {
    Get.toNamed(
      Routes.DELIVERY_DETAILS,
      arguments: DeliveryDetailsArgs(
        deliveryId: deliveryId,
        user: User.supplier,
      ),
    );
  }

  List<Delivery> getCurrentDelivery(Key tabKey) => _deliveries.value[tabKey]!;

  List<Delivery> _getFilteredDeliveries(
      List<Delivery> deliveries, DeliveryStatus status) {
    final filtered =
        deliveries.where((delivery) => delivery.status == status).toList();

    filtered.sort((a, b) => a.deliveryDate!.compareTo(b.deliveryDate!));

    return filtered;
  }

  Future<void> fetchDeliveries({bool wasForced = false}) async {
    if (!wasForced) {
      isLoading.value = true;
    }

    try {
      final allDeliveries = await _deliveriesRepository.getSupplierDeliveries();

      _deliveries.value[_pending] =
          _getFilteredDeliveries(allDeliveries, DeliveryStatus.created);
      _deliveries.value[_inProgress] =
          _getFilteredDeliveries(allDeliveries, DeliveryStatus.in_progress);
      _deliveries.value[_delivered] =
          _getFilteredDeliveries(allDeliveries, DeliveryStatus.finished);
    } catch (e) {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    } finally {
      isLoading.value = false;
    }
  }
}
