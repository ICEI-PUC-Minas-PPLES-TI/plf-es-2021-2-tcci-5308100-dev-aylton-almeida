import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/modules/delivery_complete/controllers/delivery_complete_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './delivery_complete_controller_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  group('Testing Delivery Complete Controller', () {
    // Mock
    late MockAuthController mockAuthController;

    createController() {
      return DeliveryCompleteController(
        authController: mockAuthController,
      );
    }

    setUp(() {
      mockAuthController = MockAuthController();
    });

    tearDown(() {
      reset(mockAuthController);
    });

    test('on go to start tap', () {
      // when
      final controller = createController();

      // mock
      when(mockAuthController.signOut())
          .thenAnswer((_) async => Future.value(null));

      // then
      controller.onGoToStartTap();

      // assert
      verify(mockAuthController.signOut()).called(1);
    });
  });
}
