import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/order_problems/controllers/order_problems_controller.dart';
import 'package:delivery_manager/app/modules/order_problems/views/order_problems_view.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_view.dart';
import '../../../../utils/samples/order_sample.dart';

import './order_problems_view_test.mocks.dart';

@GenerateMocks([
  TextEditingController,
  DeliveriesRepository,
  AppController,
])
void main() {
  group('Order Problems View Widget Tests', () {
    // Mock
    late MockTextEditingController mockTextEditingController;
    late MockDeliveriesRepository mockDeliveriesRepository;
    late MockAppController mockAppController;
    late Order mockOrder;

    createController() {
      return OrderProblemsController(
        appController: mockAppController,
        deliveriesRepository: mockDeliveriesRepository,
        order: mockOrder,
      );
    }

    setUp(() {
      mockAppController = MockAppController();
      mockTextEditingController = MockTextEditingController();
      mockDeliveriesRepository = MockDeliveriesRepository();

      mockOrder = orderSample.copyWith();

      Get.put(createController());
    });

    tearDown(() {
      reset(mockAppController);
      reset(mockTextEditingController);
      reset(mockDeliveriesRepository);
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('problem_submit_button');

      // pump
      await tester.pumpWidget(createTestView(OrderProblemsView()));
      await tester.pump();

      // assert
      expect(find.text('order_problems'.tr), findsOneWidget);
      expect(find.text('order_problem_header'.tr), findsOneWidget);
      expect(find.text('order_problem_subheader'.tr), findsOneWidget);
      expect(find.text('order_problem_select_hint'.tr), findsOneWidget);
      expect(find.text('order_problem_input_hint'.tr), findsOneWidget);
      expect(find.byType(OutlinedTextField), findsOneWidget);
      expect(find.text('send_problem'.tr), findsOneWidget);
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect submit button to be disabled',
      );
    });

    testWidgets('Testing problem type selected', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('problem_submit_button');

      // pump
      await tester.pumpWidget(createTestView(OrderProblemsView()));
      await tester.pump();

      // then
      await tester.tap(find.text('order_problem_select_hint'.tr));
      await tester.pumpAndSettle();
      await tester.tap(find.text('missing_product'.tr).first);
      await tester.pumpAndSettle();

      // assert
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        Get.find<OrderProblemsController>().submitProblem,
        reason: 'Expect submit button to be enabled',
      );
    });
  });
}
