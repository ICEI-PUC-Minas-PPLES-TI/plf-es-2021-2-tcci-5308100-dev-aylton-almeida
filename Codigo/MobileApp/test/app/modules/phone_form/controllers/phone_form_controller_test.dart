import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';
import 'package:delivery_manager/app/modules/phone_form/controllers/phone_form_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'phone_form_controller_test.mocks.dart';

@GenerateMocks([
  TextEditingController,
  GlobalKey,
  FormState,
  MaskTextInputFormatter,
])
void main() {
  group('Testing Phone Form Controller', () {
    // Mock
    final mockGlobalKey = MockGlobalKey<FormState>();
    final mockFormState = MockFormState();
    final mockTextEditingController = MockTextEditingController();
    final mockMaskTextInputFormatter = MockMaskTextInputFormatter();

    tearDown(() {
      reset(mockGlobalKey);
      reset(mockFormState);
      reset(mockTextEditingController);
      reset(mockMaskTextInputFormatter);
    });

    test('Controller onInit', () {
      // when
      final controller = PhoneFormController();

      // then
      Get.put(controller);

      // assert
      expect(controller.phoneFormKey, isInstanceOf<GlobalKey<FormState>>());
      expect(controller.phoneController, isInstanceOf<TextEditingController>());
      expect(controller.phoneMask, isInstanceOf<MaskTextInputFormatter>());
      expect(controller.isLoading.value, isFalse);
      expect(controller.isValid.value, isFalse);
    });

    test('Controller destruction', () async {
      // when
      final controller = PhoneFormController();
      const tag = 'controller destruction test';
      Get.put(controller, tag: tag);

      // mock
      controller.phoneController = mockTextEditingController;

      // then
      await Get.delete<PhoneFormController>(tag: tag);

      // assert
      verify(mockTextEditingController.dispose()).called(1);
    });

    test('Phone Field Validator when empty', () {
      // when
      final controller = PhoneFormController();
      const value = '';

      // mock
      when(mockMaskTextInputFormatter.getUnmaskedText()).thenReturn(value);
      controller.phoneMask = mockMaskTextInputFormatter;

      // then
      final response = controller.validator(value);

      // assert
      expect(response, 'invalid_phone_input_error'.tr);
    });

    test('Phone Field Validator when length is equal to 13', () {
      // when
      final controller = PhoneFormController();
      var value = '5531999999999';

      // mock
      when(mockMaskTextInputFormatter.getUnmaskedText()).thenReturn(value);
      controller.phoneMask = mockMaskTextInputFormatter;

      // then
      final response = controller.validator(value);

      expect(response, isNull);
    });

    test('handleFormChange when form is valid', () {
      // when
      final controller = PhoneFormController(phoneFormKey: mockGlobalKey);

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
      final controller = PhoneFormController(phoneFormKey: mockGlobalKey);

      // mock
      when(mockGlobalKey.currentState).thenReturn(mockFormState);
      when(mockFormState.validate()).thenReturn(false);

      // then
      controller.handleFormChange();

      // assert
      expect(controller.isValid.value, false);
    });

    test('setCurrentAssets when current user is deliverer', () {
      // when
      final controller = PhoneFormController(
        args: PhoneFormArgs(user: PhoneFormUser.deliverer),
      );

      // then
      controller.setCurrentAssets();

      // assert
      expect(
          controller.currentAssets['title'], 'phone_form_deliverer_header'.tr);
      expect(controller.currentAssets['btn'], 'phone_form_supplier_header'.tr);
    });

    test('setCurrentAssets when current user is supplier', () {
      // when
      final controller = PhoneFormController(
        args: PhoneFormArgs(user: PhoneFormUser.supplier),
      );

      // then
      controller.setCurrentAssets();

      // assert
      expect(controller.currentAssets['title'],
          'phone_form_supplier_sub_header'.tr);
      expect(controller.currentAssets['btn'], 'receive_code_button'.tr);
    });
  });
}