import 'package:delivery_manager/app/data/enums/delivery_status.dart';
import 'package:delivery_manager/app/data/enums/user.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/modules/delivery_details/controllers/delivery_details_controller.dart';
import 'package:delivery_manager/app/modules/delivery_details/widgets/delivery_details_header.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:flutter/material.dart';
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
    final mockOnStartTap = FunctionMock();
    final mockOnCancelTap = FunctionMock();

    setUp(() {
      delivery = deliverySample;
    });

    tearDown(() {
      reset(mockOnShareTap);
      reset(mockOnStartTap);
      reset(mockOnCancelTap);
    });

    testWidgets(
        'Testing initial state when user is supplier and delivery is created',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.supplier,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_created_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsOneWidget,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsWidgets);
      expect(find.text('delivery_estimate_time'.tr), findsNothing);
      expect(find.text('start_delivery'.tr), findsNothing);
      expect(find.text('cancel_delivery'.tr), findsNothing);
    });

    testWidgets(
        'Testing initial state when user is supplier and delivery is in progress',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery.copyWith(status: DeliveryStatus.in_progress),
          currentUser: User.supplier,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_in_progress_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsOneWidget,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsNothing);
      expect(find.text('delivery_estimate_time'.tr), findsNothing);
      expect(find.text('start_delivery'.tr), findsNothing);
      expect(find.text('cancel_delivery'.tr), findsNothing);
    });

    testWidgets(
        'Testing initial state when user is supplier and delivery is finished',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery.copyWith(status: DeliveryStatus.finished),
          currentUser: User.supplier,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_finished_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsOneWidget,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsNothing);
      expect(find.text('delivery_estimate_time'.tr), findsNothing);
      expect(find.text('start_delivery'.tr), findsNothing);
      expect(find.text('cancel_delivery'.tr), findsNothing);
    });

    testWidgets('Testing initial state when user is deliverer',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.deliverer,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_created_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsNothing,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsNothing);
      expect(find.text('delivery_estimate_time'.tr), findsOneWidget);
      expect(find.text('start_delivery'.tr), findsOneWidget);
      expect(
        tester
            .widget<LoadingButton>(find.byKey(
              const Key('start_delivery_button'),
            ))
            .onPressed,
        isNotNull,
        reason: 'Expect on start to contain passed callback',
      );
      expect(find.text('cancel_delivery'.tr), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(
              const Key('cancel_delivery_button'),
            ))
            .onPressed,
        isNotNull,
        reason: 'Expect on cancel to contain passed callback',
      );
    });

    testWidgets('Testing initial state when user is deliverer and its loading',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.deliverer,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: true,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 500));

      // assert
      expect(find.text(delivery.name!), findsOneWidget);
      expect(
        find.text('delivery_created_subtitle'
            .tr
            .replaceAll(':day', delivery.deliveryDate!.day.toString())
            .replaceAll(':hour', delivery.deliveryDate!.hour.toString())),
        findsNothing,
      );
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsNothing);
      expect(find.text('delivery_estimate_time'.tr), findsOneWidget);
      expect(find.text('start_delivery'.tr), findsNothing);
      expect(
        tester
            .widget<LoadingButton>(find.byKey(
              const Key('start_delivery_button'),
            ))
            .onPressed,
        isNull,
        reason: 'Expect on start to contain passed callback',
      );
      expect(find.text('cancel_delivery'.tr), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(
              const Key('cancel_delivery_button'),
            ))
            .onPressed,
        isNull,
        reason: 'Expect on cancel to contain passed callback',
      );
    });

    testWidgets('Testing when share button is pressed',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.supplier,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
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

    testWidgets('Testing when start button is pressed',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.deliverer,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // mock
      when(mockOnStartTap()).thenReturn(null);

      // then
      await tester.tap(find.text('start_delivery'.tr));
      await tester.pumpAndSettle();

      // assert
      verify(mockOnStartTap()).called(1);
    });

    testWidgets('Testing when cancel button is pressed',
        (WidgetTester tester) async {
      // pump
      await tester.pumpWidget(createTestMaterialWidget(
        DeliveryDetailsHeader(
          delivery: delivery,
          currentUser: User.deliverer,
          onShareTap: mockOnShareTap,
          onStartTap: mockOnStartTap,
          onCancelTap: mockOnCancelTap,
          isStartLoading: false,
        ),
      ));
      await tester.pumpAndSettle();

      // mock
      when(mockOnCancelTap()).thenReturn(null);

      // then
      await tester.tap(find.text('cancel_delivery'.tr));
      await tester.pumpAndSettle();

      // assert
      verify(mockOnCancelTap()).called(1);
    });
  });
}
