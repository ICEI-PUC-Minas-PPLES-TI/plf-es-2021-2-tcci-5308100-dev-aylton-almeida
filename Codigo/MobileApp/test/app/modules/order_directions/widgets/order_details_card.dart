import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/modules/delivery_list/widgets/delivery_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_material_widget.dart';
import '../../../../utils/function_mock.dart';
import '../../../../utils/samples/delivery_sample.dart';

void main() {
  group('Delivery List Tests', () {
    List<Delivery> deliveries = [
      deliverySample,
      deliverySample,
      deliverySample
    ];

    late FutureFunctionMock mockOnRefreshList;
    late SingleParamFunctionMock<String> mockOnTileTap;

    setUp(() {
      deliveries = [deliverySample, deliverySample, deliverySample];

      mockOnRefreshList = FutureFunctionMock();
      mockOnTileTap = SingleParamFunctionMock<String>();
    });

    tearDown(() {
      reset(mockOnRefreshList);
      reset(mockOnTileTap);
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryList(
          deliveries: deliveries,
          onRefreshList: mockOnRefreshList,
          onTileTap: mockOnTileTap,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('${deliveries[0].name}'),
        findsNWidgets(deliveries.length),
      );
      expect(
        find.text(
          'delivery_created_subtitle'
              .tr
              .replaceAll(':day', deliveries[0].deliveryDate!.day.toString())
              .replaceAll(':hour', deliveries[0].deliveryDate!.hour.toString()),
        ),
        findsNWidgets(deliveries.length),
      );
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('Testing when list tile is tapped',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryList(
          deliveries: deliveries,
          onRefreshList: mockOnRefreshList,
          onTileTap: mockOnTileTap,
        ),
      ));
      await tester.pumpAndSettle();

      // mock
      when(mockOnTileTap(deliveries[0].deliveryId!)).thenReturn(null);

      // then
      await tester.tap(find.text('${deliveries[0].name}').first);

      // assert
      verify(mockOnTileTap(deliveries[0].deliveryId!)).called(1);
    });
  });
}
