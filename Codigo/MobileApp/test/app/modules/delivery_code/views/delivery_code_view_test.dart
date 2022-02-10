import 'package:delivery_manager/app/modules/delivery_code/controllers/delivery_code_controller.dart';
import 'package:delivery_manager/app/modules/delivery_code/views/delivery_code_view.dart';
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
      await tester.pumpWidget(createTestView(const DeliveryCodeView()));
      await tester.pump();

      // then
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
    });
  });
}
