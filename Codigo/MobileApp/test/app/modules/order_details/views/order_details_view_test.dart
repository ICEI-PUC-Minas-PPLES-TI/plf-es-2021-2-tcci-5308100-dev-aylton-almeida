import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:delivery_manager/app/modules/order_details/views/order_details_view.dart';
import 'package:delivery_manager/app/widgets/product_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';

import '../../../../utils/create_test_view.dart';
import '../../../../utils/samples/order_sample.dart';
import './order_details_view_test.mocks.dart';

@GenerateMocks([DeliveriesRepository, AppController])
void main() {
  group('Order Details Widget Tests', () {
    // mock
    Order mockOrder = orderSample;

    createController({Order? order}) {
      return OrderDetailsController(
        order: order ?? mockOrder,
        deliveriesRepository: MockDeliveriesRepository(),
        appController: MockAppController(),
      );
    }

    setUp(() {
      mockOrder = orderSample;

      Get.put(createController(order: orderSample));
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestView(OrderDetailsView()));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('order_details'.tr), findsOneWidget);
      expect(
        find.text('recipient_name'.tr.replaceAll(':name', mockOrder.buyerName)),
        findsOneWidget,
      );
      expect(
        find.text(
          'delivery_address'.tr.replaceAll(
                ':address',
                mockOrder.shippingAddress.formatted,
              ),
        ),
        findsOneWidget,
      );
      expect(find.text('confirm_delivery'.tr), findsOneWidget);
      expect(find.text('register_problem'.tr), findsOneWidget);
      expect(find.text('products_list'.tr), findsOneWidget);
      expect(
        find.byType(ProductListTile),
        findsNWidgets(mockOrder.orderProducts.length),
      );
    });
  });
}
