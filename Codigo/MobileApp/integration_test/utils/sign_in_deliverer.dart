import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

Future<void> testSignInDeliverer({
  required WidgetTester tester,
  String deliveryCode = '5IMIVP',
}) async {
  // when
  const validPhone = '5531999385992';

  // Find the text field and enter the code
  expect(find.byKey(const Key('code_submit_button')), findsOneWidget);
  await tester.enterText(find.byType(OutlinedTextField), deliveryCode);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('code_submit_button')));

  await tester.pumpAndSettle();

  // Check if user was redirected to the phone form page
  expect(find.text('phone_form_subheader'.tr), findsOneWidget);
  expect(find.text('phone_input_label'.tr), findsOneWidget);
  expect(find.byKey(const Key('phone_submit_button')), findsOneWidget);

  // Enter a valid phone and check if the next page appears
  await tester.enterText(find.byType(OutlinedTextField), validPhone);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('phone_submit_button')));
  await tester.pumpAndSettle();

  // Find the delivery details page
  expect(find.text('delivery_details'.tr), findsOneWidget);
}
