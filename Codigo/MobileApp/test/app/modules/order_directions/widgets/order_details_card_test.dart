import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/modules/order_directions/widgets/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/function_mock.dart';
import '../../../../utils/samples/order_sample.dart';

void main() {
  group('Order Details Card Tests', () {
    late Order order;

    setUp(() {
      order = orderSample.copyWith();
    });

    testWidgets('Testing when closed', (WidgetTester tester) async {
      // when
      const isOpen = false;
      const estimateTime = '3 mins';
      final onOpenTap = FunctionMock();
      final onDetailsTap = FunctionMock();
      const inkWellKey = Key('order_details_card_ink_well');

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderDetailsCard(
          isOpen: isOpen,
          order: order,
          estimateTime: estimateTime,
          onOpenTap: onOpenTap,
          onDetailsTap: onDetailsTap,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(order.buyerName), findsOneWidget);
      expect(find.text(estimateTime), findsOneWidget);
      expect(tester.widget<InkWell>(find.byKey(inkWellKey)).onTap, isNotNull);
    });

    testWidgets('Testing tapped card when closed', (WidgetTester tester) async {
      // when
      const isOpen = false;
      const estimateTime = '3 mins';
      final onOpenTap = FunctionMock();
      final onDetailsTap = FunctionMock();

      // mock
      when(onOpenTap()).thenReturn(null);

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderDetailsCard(
          isOpen: isOpen,
          order: order,
          estimateTime: estimateTime,
          onOpenTap: onOpenTap,
          onDetailsTap: onDetailsTap,
        ),
      ));
      await tester.pumpAndSettle();

      // then
      await tester.tap(find.text(order.buyerName));

      // assert
      expect(find.text(order.buyerName), findsOneWidget);
      expect(find.text(estimateTime), findsOneWidget);
      verify(onOpenTap()).called(1);
    });

    testWidgets('Testing when opened', (WidgetTester tester) async {
      // when
      const isOpen = true;
      const estimateTime = '3 mins';
      final onOpenTap = FunctionMock();
      final onDetailsTap = FunctionMock();
      const inkWellKey = Key('order_details_card_ink_well');

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderDetailsCard(
          isOpen: isOpen,
          order: order,
          estimateTime: estimateTime,
          onOpenTap: onOpenTap,
          onDetailsTap: onDetailsTap,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('next_delivery'.tr), findsOneWidget);
      expect(find.text(order.buyerName), findsOneWidget);
      expect(find.text(estimateTime), findsOneWidget);
      expect(find.text('address'.tr), findsOneWidget);
      expect(find.text('delivery_time'.tr), findsOneWidget);
      expect(find.text('view_details'.tr), findsOneWidget);
      expect(tester.widget<InkWell>(find.byKey(inkWellKey)).onTap, isNull);
    });

    testWidgets('Testing tapped view details when opened',
        (WidgetTester tester) async {
      // when
      const isOpen = true;
      const estimateTime = '3 mins';
      final onOpenTap = FunctionMock();
      final onDetailsTap = FunctionMock();

      // mock
      when(onDetailsTap()).thenReturn(null);

      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        OrderDetailsCard(
          isOpen: isOpen,
          order: order,
          estimateTime: estimateTime,
          onOpenTap: onOpenTap,
          onDetailsTap: onDetailsTap,
        ),
      ));
      await tester.pumpAndSettle();

      // then
      await tester.tap(find.text('view_details'.tr));

      // assert
      expect(find.text('next_delivery'.tr), findsOneWidget);
      expect(find.text(order.buyerName), findsOneWidget);
      expect(find.text(estimateTime), findsOneWidget);
      expect(find.text('address'.tr), findsOneWidget);
      expect(find.text('delivery_time'.tr), findsOneWidget);
      expect(find.text('view_details'.tr), findsOneWidget);
      verify(onDetailsTap()).called(1);
    });
  });
}
