// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:delivery_manager/app/modules/delivery_code/controllers/delivery_code_controller.dart';
import 'package:delivery_manager/app/modules/delivery_code/views/delivery_code_view.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../../../utils/create_test_widget.dart';

void main() {
  group('Delivery Code View Widget Tests', () {
    // setUp(() {
    //   Get.lazyPut(()=>DeliveryCodeController())
    // });

    // testWidgets('Testing initial state', (WidgetTester tester) async {
    //   // when
    //   await tester.pumpWidget(createTestView(const DeliveryCodeView()));
    //   await tester.pump();

    //   // then
    //   expect(find.text('Test'), findsOneWidget);
    //   expect(
    //     find.text(
    //         'Caso não, mas deseje ver suas entregas pendentes, acesse sua conta de parceiro Zapt.'),
    //     findsOneWidget,
    //   );
    //   expect(find.text('Código'), findsOneWidget);
    // });
  });
}
