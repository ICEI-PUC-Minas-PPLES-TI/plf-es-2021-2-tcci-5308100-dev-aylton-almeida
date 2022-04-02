import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/controllers/delivery_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/samples/delivery_sample.dart';
import 'delivery_details_controller_test.mocks.dart';

@GenerateMocks([DeliveriesRepository, AppController, TabController])
void main() {
  group('Testing Delivery Details Controller', () {
    // Mock
    late MockDeliveriesRepository mockDeliveriesRepository;
    late MockAppController mockAppController;
    late MockTabController mockTabController;

    createController({
      String deliveryId = '1',
      User currentUser = User.supplier,
      Delivery? delivery,
    }) {
      final storageRepository = StorageRepository(
        storageClient: const FlutterSecureStorage(),
      );

      return DeliveryDetailsController(
        deliveryId: deliveryId,
        delivery: delivery,
        currentUser: currentUser,
        deliveriesRepository: mockDeliveriesRepository,
        appController: mockAppController,
        authController: AuthController(
          authRepository: AuthRepository(
            apiClient: ApiClient(
              httpClient: Client(),
              storageRepository: storageRepository,
            ),
          ),
          storageRepository: storageRepository,
        ),
      );
    }

    setUp(() {
      mockDeliveriesRepository = MockDeliveriesRepository();
      mockAppController = MockAppController();
      mockTabController = MockTabController();
    });

    tearDown(() {
      reset(mockDeliveriesRepository);
      reset(mockAppController);
      reset(mockTabController);
    });

    test('Controller onInit when Delivery found', () async {
      // when
      const deliveryId = '1';
      final controller = createController(deliveryId: deliveryId);

      // mock
      when(mockAppController.showAlert(
              text: 'generic_error_msg'.tr, type: AlertType.error))
          .thenReturn(null);
      when(mockDeliveriesRepository.getDelivery(deliveryId)).thenAnswer(
          (_) => Future.value(Delivery.fromJson({'deliveryId': deliveryId})));

      // then
      controller.onInit();

      // assert
      await untilCalled(mockDeliveriesRepository.getDelivery(deliveryId));
      expect(controller.tabsController, isInstanceOf<TabController>());
      expect(controller.isLoading.value, isFalse);
      verifyNever(mockAppController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error));
    });

    test('Controller onInit when Delivery not found', () async {
      // when
      const deliveryId = '1';
      final controller = createController(deliveryId: deliveryId);

      // mock
      when(mockAppController.showAlert(
              text: 'generic_error_msg'.tr, type: AlertType.error))
          .thenReturn(null);
      when(mockDeliveriesRepository.getDelivery(deliveryId))
          .thenThrow(Exception());

      // then
      controller.onInit();

      // assert
      await untilCalled(mockDeliveriesRepository.getDelivery(deliveryId));
      expect(controller.tabsController, isInstanceOf<TabController>());
      expect(controller.isLoading.value, isFalse);
      verify(mockAppController.showAlert(
              text: 'generic_error_msg'.tr, type: AlertType.error))
          .called(1);
    });

    test('Controller destruction', () async {
      // when
      final controller = createController();
      const tag = 'controller destruction test';
      Get.put(controller, tag: tag);

      // mock
      controller.tabsController = mockTabController;
      when(mockTabController.dispose()).thenReturn(null);

      // then
      await Get.delete<DeliveryDetailsController>(tag: tag);

      // assert
      verify(mockTabController.dispose()).called(1);
    });

    test('Get tab data when current tab is products', () {
      // when
      const tabKey = Key('products');
      final controller = createController(delivery: deliverySample);

      // then
      final response = controller.getTabData(tabKey);

      // assert
      expect(
        response[0],
        equals(
          const OrderProduct(
            orderProductId: 1,
            productSku: 1,
            name: 'product 1',
            quantity: 2,
            variant: 'variant 1',
          ),
        ),
      );
      expect(
        response[1],
        equals(
          const OrderProduct(
            orderProductId: 2,
            productSku: 2,
            name: 'product 2',
            quantity: 4,
            variant: 'variant 2',
          ),
        ),
      );
    });

    test('Get tab data when current tab is orders', () {
      // when
      const tabKey = Key('orders');

      final controller = createController(delivery: deliverySample);

      // then
      final response = controller.getTabData(tabKey);

      // assert
      expect(response, deliverySample.orders!);
    });
  });
}
