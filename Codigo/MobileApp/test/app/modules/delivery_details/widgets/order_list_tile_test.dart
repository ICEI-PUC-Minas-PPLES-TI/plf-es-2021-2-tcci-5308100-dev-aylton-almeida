import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/order_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/samples/delivery_sample.dart';

void main() {
  group('Order List Tile Tests', () {
    Order order = deliverySample.orders![0];

    setUp(() {
      order = deliverySample.orders![0];
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderListTile(order: order),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(order.buyerName), findsOneWidget);
      for (final orderProduct in order.orderProducts) {
        expect(find.text(orderProduct.name), findsWidgets);
        expect(find.text('${orderProduct.quantity}x'), findsWidgets);
      }
    });

    testWidgets("Testing when product name is to big it's trimmed",
        (WidgetTester tester) async {
      // when
      order.orderProducts[0] = order.orderProducts[0].copyWith(
          name: 'This is a very long product name and should be trimmed');

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderListTile(order: order),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(order.buyerName), findsOneWidget);
      expect(find.text(order.orderProducts[0].name), findsNothing);
      expect(find.text('This is a very long product na...'), findsOneWidget);
    });
  });
}
