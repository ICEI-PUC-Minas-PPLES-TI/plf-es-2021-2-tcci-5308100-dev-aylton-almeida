import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/delivery_details/controllers/delivery_details_controller.dart';
import 'package:delivery_manager/app/modules/delivery_details/views/delivery_details_view.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/delivery_details_header.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/order_list_tile.dart';
import 'package:delivery_manager/app/widgets/product_list_tile.dart';
import 'package:delivery_manager/app/widgets/authenticated_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_view.dart';
import '../../../../utils/samples/delivery_sample.dart';
import 'delivery_details_view_test.mocks.dart';

@GenerateMocks([DeliveriesRepository, AppController, TabController])
void main() {
  group('Delivery Details Widget Tests', () {
    // mock
    late MockDeliveriesRepository mockDeliveriesRepository;
    late MockAppController mockAppController;
    late MockTabController mockTabController;

    createController({User currentUser = User.supplier}) {
      final storageRepository = StorageRepository(
        storageClient: const FlutterSecureStorage(),
      );

      return DeliveryDetailsController(
        deliveryId: deliverySample.deliveryId,
        delivery: deliverySample,
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

      when(mockDeliveriesRepository.getDelivery(deliverySample.deliveryId))
          .thenAnswer((_) => Future.value(deliverySample));

      Get.lazyPut(createController);
    });

    tearDown(() {
      reset(mockDeliveriesRepository);
      reset(mockAppController);
      reset(mockTabController);
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestView(DeliveryDetailsView()));
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(find.text('delivery_details'.tr), findsOneWidget);
      expect(find.byType(AuthenticatedAppBar), findsOneWidget);
      expect(find.byType(DeliveryDetailsHeader), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.text('products'.tr), findsOneWidget);
      expect(find.text('orders'.tr), findsOneWidget);
      expect(find.byType(ProductListTile), findsNWidgets(1));
      expect(find.text('product 1'), findsWidgets);
      expect(find.byType(OrderListTile), findsNothing);
      expect(find.text('buyer name'), findsNothing);
    });

    testWidgets('Testing orders tab change', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestView(DeliveryDetailsView()));
      await tester.pumpAndSettle();

      // then
      await tester.tap(find.text('orders'.tr));
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
      expect(find.text('delivery_details'.tr), findsOneWidget);
      expect(find.byType(AuthenticatedAppBar), findsOneWidget);
      expect(find.byType(DeliveryDetailsHeader), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.text('products'.tr), findsOneWidget);
      expect(find.text('orders'.tr), findsOneWidget);
      expect(find.byType(ProductListTile), findsNothing);
      expect(find.text('product 1'), findsWidgets);
      expect(find.byType(OrderListTile), findsNWidgets(1));
      expect(find.text('buyer name'), findsWidgets);
    });
  });
}
