import 'package:delivery_manager/app/modules/delivery_code/controllers/delivery_code_controller.dart';
import 'package:delivery_manager/app/modules/delivery_code/views/delivery_code_view.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../../../utils/create_test_widget.dart';

void main() {
  group('Delivery Code View Widget Tests', () {
    setUp(() {
      Get.lazyPut(() => DeliveryCodeController());
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      await tester.pumpWidget(createTestView(const DeliveryCodeView()));
      await tester.pump();

      // assert
      expect(
        find.text('você possui um código?'.tr.capitalizeFirst!),
        findsOneWidget,
      );
      expect(
        find.text('caso não, mas deseje ver suas entregas'.tr.capitalizeFirst!),
        findsOneWidget,
      );
      expect(
          find.text('código de 6 dígitos'.tr.capitalizeFirst!), findsOneWidget);
      expect(find.text('Código'.tr.capitalizeFirst!), findsOneWidget);
      expect(
        find.text("verificar código de entrega".tr.capitalizeFirst!),
        findsOneWidget,
      );
      expect(
        find.text('digite o código de entrega'.tr.capitalizeFirst!),
        findsNothing,
      );
      expect(
        find.text('código de entrega inválido'.tr.capitalizeFirst!),
        findsNothing,
      );
      expect(
        tester.widget<ElevatedButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect initial submit button to be disabled',
      );
      expect(
        find.text("sou um parceiro trela".tr.capitalizeFirst!),
        findsOneWidget,
      );
    });

    testWidgets('Testing when invalid code', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const code = '1234';
      await tester.pumpWidget(createTestView(const DeliveryCodeView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('código de entrega inválido'.tr.capitalizeFirst!),
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
      const code = '123456';
      await tester.pumpWidget(createTestView(const DeliveryCodeView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('digite o código de entrega'.tr.capitalizeFirst!),
        findsNothing,
      );
      expect(
        find.text('código de entrega inválido'.tr.capitalizeFirst!),
        findsNothing,
      );
      expect(
        tester.widget<ElevatedButton>(find.byKey(submitButtonKey)).onPressed,
        Get.find<DeliveryCodeController>().submitForm,
        reason: 'Expect submit button to be enabled',
      );
    });
  });
}
