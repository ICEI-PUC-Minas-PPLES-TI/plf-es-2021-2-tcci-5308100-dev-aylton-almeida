import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/modules/delivery_complete/controllers/delivery_complete_controller.dart';
import 'package:delivery_manager/app/modules/delivery_complete/views/delivery_complete_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/create_test_view.dart';

import './delivery_complete_view_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  group('Delivery Complete Widget Tests', () {
    // Mock
    late MockAuthController mockAuthController;

    createController() {
      return DeliveryCompleteController(
        authController: mockAuthController,
      );
    }

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockAuthController = MockAuthController();

      Get.lazyPut(() => createController());
    });

    tearDown(() {
      reset(mockAuthController);
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // when
      const backButton = Key('go_back_button');

      // pump
      await tester.pumpWidget(createTestView(DeliveryCompleteView()));
      await tester.pumpAndSettle();

      // assert
      expect(find.text('delivery_complete_header'.tr), findsOneWidget);
      expect(find.text('delivery_complete_subheader'.tr), findsOneWidget);
      expect(find.text('go_back_to_start'.tr), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byKey(backButton)).onPressed,
        Get.find<DeliveryCompleteController>().onGoToStartTap,
      );
    });
  });
}
