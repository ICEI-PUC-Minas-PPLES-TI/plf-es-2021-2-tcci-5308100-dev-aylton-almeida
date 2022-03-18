import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/delivery_code_form/controllers/delivery_code_form_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delivery_code_form_controller_test.mocks.dart';

@GenerateMocks([
  TextEditingController,
  GlobalKey,
  FormState,
  DeliveriesRepository,
])
void main() {
  group('Testing Delivery Code Form Controller', () {
    // Mock
    late MockGlobalKey<FormState> mockGlobalKey;
    late MockFormState mockFormState;
    late MockTextEditingController mockTextEditingController;

    createDeliveryCodeFormController({
      AppController? appController,
      DeliveriesRepository? deliveriesRepository,
      GlobalKey<FormState>? codeFormKey,
    }) {
      return DeliveryCodeFormController(
        codeFormKey: codeFormKey,
        deliveriesRepository:
            deliveriesRepository ?? MockDeliveriesRepository(),
      );
    }

    setUp(() {
      mockGlobalKey = MockGlobalKey<FormState>();
      mockFormState = MockFormState();
      mockTextEditingController = MockTextEditingController();
    });

    tearDown(() {
      reset(mockGlobalKey);
      reset(mockFormState);
      reset(mockTextEditingController);
    });

    test('Controller onInit', () {
      // when
      final controller = createDeliveryCodeFormController();

      // then
      Get.put(controller);

      // assert
      expect(controller.codeFormKey, isInstanceOf<GlobalKey<FormState>>());
      expect(controller.codeController, isInstanceOf<TextEditingController>());
      expect(controller.isLoading.value, isFalse);
      expect(controller.isValid.value, isFalse);
    });

    test('Controller destruction', () async {
      // when
      final controller = createDeliveryCodeFormController();
      const tag = 'controller destruction test';
      Get.put(controller, tag: tag);

      // mock
      controller.codeController = mockTextEditingController;

      // then
      await Get.delete<DeliveryCodeFormController>(tag: tag);

      // assert
      verify(mockTextEditingController.dispose()).called(1);
    });

    test('Code Field Validator when empty', () {
      // when
      final controller = createDeliveryCodeFormController();
      const value = '';

      // then
      final response = controller.validator(value);

      // assert
      expect(response, 'empty_delivery_code_input_error'.tr);
    });

    test('Code Field Validator when null', () {
      // when
      final controller = createDeliveryCodeFormController();
      const value = null;

      // then
      final response = controller.validator(value);

      expect(response, 'empty_delivery_code_input_error'.tr);
    });

    test('Code Field Validator when length is different than 6', () {
      // when
      final controller = createDeliveryCodeFormController();
      var value = '1478';

      // then
      final response = controller.validator(value);

      expect(response, 'invalid_delivery_code_input_error'.tr);
    });

    test('Code Field Validator when valid code', () {
      // when
      final controller = createDeliveryCodeFormController();
      const value = 'ABC123';

      // then
      final response = controller.validator(value);

      expect(response, isNull);
    });

    test('handleFormChange when form is valid', () {
      // when
      final controller =
          createDeliveryCodeFormController(codeFormKey: mockGlobalKey);

      // mock
      when(mockGlobalKey.currentState).thenReturn(mockFormState);
      when(mockFormState.validate()).thenReturn(true);

      // then
      controller.handleFormChange();

      // assert
      expect(controller.isValid.value, true);
    });

    test('handleFormChange when form is invalid', () {
      // when
      final controller =
          createDeliveryCodeFormController(codeFormKey: mockGlobalKey);

      // mock
      when(mockGlobalKey.currentState).thenReturn(mockFormState);
      when(mockFormState.validate()).thenReturn(false);

      // then
      controller.handleFormChange();

      // assert
      expect(controller.isValid.value, false);
    });
  });
}
