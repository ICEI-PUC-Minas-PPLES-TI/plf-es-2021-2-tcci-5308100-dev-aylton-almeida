import 'package:delivery_manager/app/data/models/order_product.dart';
import 'package:delivery_manager/app/widgets/product_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/samples/delivery_sample.dart';

void main() {
  group('Product List Tile Tests', () {
    OrderProduct product = deliverySample.orders![0].orderProducts[0];

    setUp(() {
      product = deliverySample.orders![0].orderProducts[0];
    });

    testWidgets('Testing initial state when product has variant',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        ProductListTile(orderProduct: product),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(product.name), findsOneWidget);
      expect(find.text(product.variant), findsOneWidget);
      expect(find.text('${product.quantity}x'), findsOneWidget);
    });

    testWidgets('Testing initial state when product has no variant',
        (WidgetTester tester) async {
      // when
      final testProduct = product.copyWith(variant: '');

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        ProductListTile(orderProduct: testProduct),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(testProduct.name), findsOneWidget);
      expect(find.text(testProduct.variant), findsNothing);
      expect(find.text('${testProduct.quantity}x'), findsOneWidget);
    });
  });
}
