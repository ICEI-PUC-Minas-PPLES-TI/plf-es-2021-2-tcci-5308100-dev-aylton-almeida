import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
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

  late DeliveriesRepository _deliveriesRepository;
  late AppController _appController;
  late AuthController _authController;

  late String _deliveryId;
  late User currentUser;

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
    User? currentUser,
    Delivery? delivery,
  }) {
    _deliveryId =
        (Get.arguments as DeliveryDetailsArgs?)?.deliveryId ?? deliveryId!;
    this.currentUser =
        (Get.arguments as DeliveryDetailsArgs?)?.user ?? currentUser!;
    _delivery.value = delivery;
    _appController = appController;
    _authController = authController;
    _deliveriesRepository = deliveriesRepository;
  }

  Supplier? get supplier => _authController.supplier.value;

  Delivery? get delivery => _delivery.value;

  // TODO: test
  bool get showBackButton => currentUser == User.supplier;

  @override
  void onInit() {
    super.onInit();

    tabsController = TabController(length: tabs.length, vsync: this);

    _fetchDelivery();
  }

  @override
  void onClose() {
    tabsController.dispose();
    super.onClose();
  }

  List<OrderProduct> _getProducts(Delivery delivery) {
    final flatList =
        flatten(_delivery.value!.orders!.map((order) => order.orderProducts));
    final grouped = groupBy(flatList, (OrderProduct item) => item.productSku);

    return grouped.values.map((e) {
      return OrderProduct(
        orderProductId: e[0].orderProductId,
        productSku: e[0].productSku,
        name: e[0].name,
        quantity: grouped[e[0].productSku]!.map(((e) => e.quantity)).sum,
        variant: e[0].variant,
      );
    }).toList();
  }

  List<Order> _getOrders(Delivery delivery) {
    return delivery.orders!;
  }

  List<dynamic> getTabData(Key currentTab) {
    if (currentTab == _products) {
      return _productItems.value ??= _getProducts(_delivery.value!);
    } else if (currentTab == _orders) {
      return _orderItems.value ??= _getOrders(_delivery.value!);
    }

    return [];
  }

  Future<void> _fetchDelivery() async {
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

  void onShareTap() => Share.share(
        'share_with_deliverer'
            .tr
            .replaceAll(':name', _delivery.value!.name!)
            .replaceAll(':code', _delivery.value!.accessCode!),
      );

  void onStartTap() {
    _appController.showDialog(
      title: Text('start_delivery_dialog_title'.tr),
      cancelText: 'cancel'.tr,
      confirmText: 'confirm'.tr,
      onConfirmTap: () {},
    );
  }

  void onCancelTap() {
    _appController.showDialog(
      title: Text('cancel_delivery_dialog_title'.tr),
      cancelText: 'cancel'.tr,
      confirmText: 'confirm'.tr,
      onConfirmTap: _authController.signOut,
    );
  }

  void goBack() => Get.back();
}
