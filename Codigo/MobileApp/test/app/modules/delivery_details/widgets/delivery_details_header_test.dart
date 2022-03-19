import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/delivery_details_header.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/function_mock.dart';
import '../../../../utils/samples/delivery_sample.dart';

void main() {
  group('Delivery Details Header Tests', () {
    Delivery delivery = deliverySample;

    final mockOnShareTap = FunctionMock();

    setUp(() {
      delivery = deliverySample;
    });

    tearDown(() {
      reset(mockOnShareTap);
    });

    testWidgets('Testing initial state when should show share button',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          onShareTap: mockOnShareTap,
          showShareBtn: true,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsOneWidget,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsWidgets);
    });

    testWidgets('Testing initial state when should not show share button',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          onShareTap: mockOnShareTap,
          showShareBtn: false,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsOneWidget,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsNothing);
    });

    testWidgets('Testing when share button is pressed',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          onShareTap: mockOnShareTap,
          showShareBtn: true,
        ),
      ));
      await tester.pumpAndSettle();

      // mock
      when(mockOnShareTap()).thenReturn(null);

      // then
      await tester.tap(find.text('share_delivery_with_deliverer'.tr));
      await tester.pumpAndSettle();

      // assert
      verify(mockOnShareTap()).called(1);
    });
  });
}
