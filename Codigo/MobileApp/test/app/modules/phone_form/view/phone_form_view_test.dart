import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_args.dart';
import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';
import 'package:delivery_manager/app/modules/phone_form/controllers/phone_form_controller.dart';
import 'package:delivery_manager/app/modules/phone_form/views/phone_form_view.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../../../utils/create_test_view.dart';

void main() {
  group('Phone Form View Widget Tests', () {
    const submitButtonKey = Key('phone_submit_button');

    setUp(() {
      Get.lazyPut(
        () => PhoneFormController(),
      );
    });

    testWidgets('Testing deliverer initial state', (WidgetTester tester) async {
      // when
      await Get.delete<PhoneFormController>();
      Get.put(PhoneFormController(
        args: PhoneFormArgs(user: PhoneFormUser.deliverer),
      ));

      // pump
      await tester.pumpWidget(createTestView(PhoneFormView()));
      await tester.pump();

      // assert
      expect(
        find.text('phone_form_deliverer_header'.tr),
        findsOneWidget,
      );
      expect(
        find.text('phone_form_sub_header'.tr),
        findsOneWidget,
      );
      expect(find.text('phone_input_label'.tr), findsOneWidget);
      expect(find.text('phone_input_hint'.tr), findsOneWidget);
      expect(
        find.text("phone_form_deliverer_button".tr),
        findsOneWidget,
      );
      expect(
        find.text('invalid_phone_input_error'.tr),
        findsNothing,
      );
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect initial submit button to be disabled',
      );
    });

    testWidgets('Testing supplier initial state', (WidgetTester tester) async {
      // when
      await Get.delete<PhoneFormController>();
      Get.put(PhoneFormController(
        args: PhoneFormArgs(user: PhoneFormUser.supplier),
      ));

      // pump
      await tester.pumpWidget(createTestView(PhoneFormView()));
      await tester.pump();

      // assert
      expect(
        find.text('phone_form_supplier_header'.tr),
        findsOneWidget,
      );
      expect(
        find.text('phone_form_sub_header'.tr),
        findsOneWidget,
      );
      expect(find.text('phone_input_label'.tr), findsOneWidget);
      expect(find.text('phone_input_hint'.tr), findsOneWidget);
      expect(
        find.text("phone_form_supplier_button".tr),
        findsOneWidget,
      );
      expect(
        find.text('invalid_phone_input_error'.tr),
        findsNothing,
      );
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect initial submit button to be disabled',
      );
    });

    testWidgets('Testing when invalid phone', (WidgetTester tester) async {
      // when
      const phone = '1234';

      // pump
      await tester.pumpWidget(createTestView(PhoneFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), phone);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('invalid_phone_input_error'.tr),
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
      const phone = '+55 (31) 99999 9999';

      // pump
      await tester.pumpWidget(createTestView(PhoneFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), phone);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('invalid_phone_input_error'.tr),
        findsNothing,
      );
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        Get.find<PhoneFormController>().submitForm,
        reason: 'Expect submit button to be enabled',
      );
    });
  });
}
