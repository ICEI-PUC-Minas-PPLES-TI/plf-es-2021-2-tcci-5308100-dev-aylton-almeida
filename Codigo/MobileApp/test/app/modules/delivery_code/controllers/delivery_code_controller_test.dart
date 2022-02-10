import 'package:delivery_manager/app/modules/delivery_code/controllers/delivery_code_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delivery_code_controller_test.mocks.dart';

@GenerateMocks([TextEditingController, GlobalKey, FormState])
void main() {
  group('Testing Delivery Code Controller', () {
    // Mock
    final mockGlobalKey = MockGlobalKey<FormState>();
    final mockFormState = MockFormState();
    final mockTextEditingController = MockTextEditingController();

    tearDown(() {
      reset(mockGlobalKey);
      reset(mockFormState);
      reset(mockTextEditingController);
    });

    test('Controller onInit', () {
      // when
      final controller = DeliveryCodeController();

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
      final controller = DeliveryCodeController();
      const tag = 'controller destruction test';
      Get.put(controller, tag: tag);

      // mock
      controller.codeController = mockTextEditingController;

      // then
      await Get.delete<DeliveryCodeController>(tag: tag);

      // assert
      verify(mockTextEditingController.dispose()).called(1);
    });

    test('Code Field Validator when empty', () {
      // when
      final controller = DeliveryCodeController();
      const value = '';

      // then
      final response = controller.validator(value);

      // assert
      expect(response, 'Digite o código de entrega');
    });

    test('Code Field Validator when null', () {
      // when
      final controller = DeliveryCodeController();
      const value = null;

      // then
      final response = controller.validator(value);

      expect(response, 'Digite o código de entrega');
    });

    test('Code Field Validator when length is different than 6', () {
      // when
      final controller = DeliveryCodeController();
      var value = '1478';

      // then
      final response = controller.validator(value);

      expect(response, 'Código de entrega inválido');
    });

    test('Code Field Validator when smaller not int', () {
      // when
      final controller = DeliveryCodeController();
      const value = 'abceac';

      // then
      final response = controller.validator(value);

      expect(response, 'Código de entrega inválido');
    });

    test('handleFormChange when form is valid', () {
      // when
      final controller = DeliveryCodeController(codeFormKey: mockGlobalKey);

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
      final controller = DeliveryCodeController(codeFormKey: mockGlobalKey);

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
