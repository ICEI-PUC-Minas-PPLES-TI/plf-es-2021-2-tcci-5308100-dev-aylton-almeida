import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:delivery_manager/app/data/models/supplier.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/arguments/delivery_details_args.dart';
import 'package:delivery_manager/app/utils/flatten.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DeliveryDetailsController extends GetxController
    with SingleGetTickerProviderMixin {
  static const _products = Key('products');
  static const _orders = Key('orders');

  final DeliveriesRepository _deliveriesRepository;
  final AppController _appController;
  final AuthController _authController;

  final String _deliveryId;

  late TabController tabsController;

  final tabs = <Tab>[
    Tab(key: _products, text: 'products'.tr),
    Tab(key: _orders, text: 'orders'.tr),
  ];

  final isLoading = false.obs;
  final Rx<Delivery?> _delivery = Rx(null);
  final _orderItems = Rx<List<Order>?>(null);
  final _productItems = Rx<List<OrderProduct>?>(null);

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

  bool get shouldShowShareButton =>
      _delivery.value?.status == DeliveryStatus.created;

  @override
  void onInit() {
    // TODO: test
    super.onInit();

    tabsController = TabController(length: tabs.length, vsync: this);

    fetchDelivery();
  }

  @override
  void onClose() {
    // TODO: test
    tabsController.dispose();
    super.onClose();
  }

  List<OrderProduct> getProducts(Delivery delivery) {
    // TODO: test
    final flatList =
        flatten(_delivery.value!.orders!.map((order) => order.orderProducts));
    final grouped = groupBy(flatList, (OrderProduct item) => item.productSku);

    return grouped.values.map((e) => e[0]).toList();
  }

  List<Order> getOrders(Delivery delivery) {
    // TODO: test

    return delivery.orders!;
  }

  List<dynamic> getTabData(Key currentTab) {
    // TODO: test
    if (currentTab == _products) {
      return _productItems.value ??= getProducts(_delivery.value!);
    } else if (currentTab == _orders) {
      return _orderItems.value ??= getOrders(_delivery.value!);
    }

    return [];
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
