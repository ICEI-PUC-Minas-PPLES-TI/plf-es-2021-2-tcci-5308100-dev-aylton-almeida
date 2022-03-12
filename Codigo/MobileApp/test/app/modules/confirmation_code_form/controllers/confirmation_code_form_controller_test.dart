import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/controllers/confirmation_code_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'confirmation_code_form_controller_test.mocks.dart';

@GenerateMocks([
  TextEditingController,
  GlobalKey,
  FormState,
])
void main() {
  group('Testing Confirmation Code Form Controller', () {
    // Mock
    late MockGlobalKey<FormState> mockGlobalKey;
    late MockFormState mockFormState;
    late MockTextEditingController mockTextEditingController;

    createFormController({GlobalKey<FormState>? codeFormKey}) {
      final storageRepository = StorageRepository(
        storageClient: const FlutterSecureStorage(),
      );

      return ConfirmationCodeFormController(
        codeFormKey: codeFormKey,
        appController: AppController(),
        authController: AuthController(
          authRepository: AuthRepository(
            apiClient: ApiClient(
              httpClient: Client(),
              storageRepository: storageRepository,
            ),
          ),
          storageRepository: storageRepository,
        ),
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
      final controller = createFormController();

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
      final controller = createFormController();
      const tag = 'controller destruction test';
      Get.put(controller, tag: tag);

      // mock
      controller.codeController = mockTextEditingController;

      // then
      await Get.delete<ConfirmationCodeFormController>(tag: tag);

      // assert
      verify(mockTextEditingController.dispose()).called(1);
    });

    test('Code Field Validator when empty', () {
      // when
      final controller = createFormController();
      const value = '';

      // then
      final response = controller.validator(value);

      // assert
      expect(response, 'empty_confirmation_code_input_error'.tr);
    });

    test('Code Field Validator when null', () {
      // when
      final controller = createFormController();
      const value = null;

      // then
      final response = controller.validator(value);

      expect(response, 'empty_confirmation_code_input_error'.tr);
    });

    test('Code Field Validator when length is different than 5', () {
      // when
      final controller = createFormController();
      var value = '147';

      // then
      final response = controller.validator(value);

      expect(response, 'invalid_confirmation_code_input_error'.tr);
    });

    test('Code Field Validator when smaller not int', () {
      // when
      final controller = createFormController();
      const value = 'abcea';

      // then
      final response = controller.validator(value);

      expect(response, 'invalid_confirmation_code_input_error'.tr);
    });

    test('Code Field Validator when valid code', () {
      // when
      final controller = createFormController();
      const value = '12345';

      // then
      final response = controller.validator(value);

      expect(response, isNull);
    });

    test('handleFormChange when form is valid', () {
      // when
      final controller = createFormController(codeFormKey: mockGlobalKey);

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
      final controller = createFormController(codeFormKey: mockGlobalKey);

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
