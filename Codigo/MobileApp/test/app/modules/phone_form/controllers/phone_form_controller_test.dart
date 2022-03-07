import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';
import 'package:delivery_manager/app/modules/phone_form/controllers/phone_form_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
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
    createFormController(
        {PhoneFormArgs? args, GlobalKey<FormState>? phoneFormKey}) {
      final storageRepository = StorageRepository(
        storageClient: const FlutterSecureStorage(),
      );

      return PhoneFormController(
          args: args,
          phoneFormKey: phoneFormKey,
          appController: AppController(),
          authController: AuthController(
            authRepository: AuthRepository(
              apiClient: ApiClient(
                httpClient: Client(),
                storageRepository: storageRepository,
              ),
            ),
            storageRepository: storageRepository,
          ));
    }

    // Mock
    late MockGlobalKey<FormState> mockGlobalKey;
    late MockFormState mockFormState;
    late MockTextEditingController mockTextEditingController;
    late MockMaskTextInputFormatter mockMaskTextInputFormatter;

    setUp(() {
      mockGlobalKey = MockGlobalKey<FormState>();
      mockFormState = MockFormState();
      mockTextEditingController = MockTextEditingController();
      mockMaskTextInputFormatter = MockMaskTextInputFormatter();
    });

    tearDown(() {
      reset(mockGlobalKey);
      reset(mockFormState);
      reset(mockTextEditingController);
      reset(mockMaskTextInputFormatter);
    });

    test('Controller onInit', () {
      // when
      final controller = createFormController();

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
      final controller = createFormController();
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
      final controller = createFormController();
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
      final controller = createFormController();
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
      final controller = createFormController(phoneFormKey: mockGlobalKey);

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
      final controller = createFormController(phoneFormKey: mockGlobalKey);

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
      final controller = createFormController(
        args: PhoneFormArgs(user: PhoneFormUser.deliverer),
      );

      // then
      controller.setCurrentAssets();

      // assert
      expect(
          controller.currentAssets['title'], 'phone_form_deliverer_header'.tr);
      expect(controller.currentAssets['btn'], 'phone_form_deliverer_button'.tr);
    });

    test('setCurrentAssets when current user is supplier', () {
      // when
      final controller = createFormController(
        args: PhoneFormArgs(user: PhoneFormUser.supplier),
      );

      // then
      controller.setCurrentAssets();

      // assert
      expect(
          controller.currentAssets['title'], 'phone_form_supplier_header'.tr);
      expect(controller.currentAssets['btn'], 'phone_form_supplier_button'.tr);
    });
  });
}
