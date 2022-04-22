import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/auth_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/arguments/confirmation_code_form_args.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/controllers/confirmation_code_form_controller.dart';
import 'package:delivery_manager/app/modules/confirmation_code_form/views/confirmation_code_form_view.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../../utils/create_test_view.dart';

void main() {
  group('Confirmation Code View Form Widget Tests', () {
    const currentPhone = '+55 (11) 99999-9999';

    createFormController() {
      final storageRepository = StorageRepository(
        storageClient: const FlutterSecureStorage(),
      );

      return ConfirmationCodeFormController(
        args: ConfirmationCodeFormArgs(currentPhone: currentPhone),
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
      Get.lazyPut(createFormController);
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const resendButtonKey = Key('confirmation_code_resend_button');
      const changeNumberButtonKey =
          Key('confirmation_code_change_number_button');

      // pump
      await tester.pumpWidget(createTestView(ConfirmationCodeFormView()));
      await tester.pump();

      // assert
      expect(
        find.text('confirmation_code_form_header'.tr),
        findsOneWidget,
      );
      expect(
        find.text('confirmation_code_form_subheader'
            .tr
            .replaceAll(':phone', currentPhone)),
        findsOneWidget,
      );
      expect(find.text('confirmation_code_input_label'.tr), findsOneWidget);
      expect(find.text('code_input_hint'.tr), findsOneWidget);
      expect(
        find.text("verify_code_button".tr),
        findsOneWidget,
      );
      expect(
        find.text('empty_confirmation_code_input_error'.tr),
        findsNothing,
      );
      expect(
        find.text('invalid_confirmation_code_input_error'.tr),
        findsNothing,
      );
      expect(find.text('resend_code_button'.tr), findsOneWidget);
      expect(
        tester.widget<TextButton>(find.byKey(resendButtonKey)).onPressed,
        Get.find<ConfirmationCodeFormController>().resendCode,
        reason: 'Expect resend button to be enabled',
      );
      expect(find.text('change_number_button'.tr), findsOneWidget);
      expect(
        tester.widget<TextButton>(find.byKey(changeNumberButtonKey)).onPressed,
        Get.find<ConfirmationCodeFormController>().goBack,
        reason: 'Expect change number button to be enabled',
      );
      expect(find.text('verify_code_button'.tr), findsOneWidget);
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect initial submit button to be disabled',
      );
    });

    testWidgets('Testing when invalid code', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const code = '1234';

      // pump
      await tester.pumpWidget(createTestView(ConfirmationCodeFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('invalid_confirmation_code_input_error'.tr),
        findsOneWidget,
      );
      expect(
        tester.widget<ElevatedButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect submit button to be disabled',
      );
    });

    testWidgets('Testing when valid code', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const code = '12345';

      // pump
      await tester.pumpWidget(createTestView(ConfirmationCodeFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('empty_confirmation_code_input_error'.tr),
        findsNothing,
      );
      expect(
        tester.widget<ElevatedButton>(find.byKey(submitButtonKey)).onPressed,
        Get.find<ConfirmationCodeFormController>().submitForm,
        reason: 'Expect submit button to be enabled',
      );
    });
  });
}
