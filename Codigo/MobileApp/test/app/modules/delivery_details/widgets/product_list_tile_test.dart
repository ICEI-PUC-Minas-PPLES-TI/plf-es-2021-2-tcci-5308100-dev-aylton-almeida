import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/product_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/samples/delivery_sample.dart';

void main() {
  group('Product List Tile Tests', () {
    OrderProduct product = deliverySample.orders![0].orderProducts[0];

    setUp(() {
      product = deliverySample.orders![0].orderProducts[0];
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        ProductListTile(orderProduct: product),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(product.name), findsOneWidget);
      expect(find.text('${product.quantity}x'), findsOneWidget);
    });
  });
}
