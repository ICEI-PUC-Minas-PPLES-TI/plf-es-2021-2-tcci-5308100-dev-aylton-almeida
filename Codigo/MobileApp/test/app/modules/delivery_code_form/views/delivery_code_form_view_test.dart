import 'package:delivery_manager/app/data/provider/api_client.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:delivery_manager/app/modules/delivery_code_form/controllers/delivery_code_form_controller.dart';
import 'package:delivery_manager/app/modules/delivery_code_form/views/delivery_code_form_view.dart';
import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../../utils/create_test_view.dart';

void main() {
  group('Delivery Code View Form Widget Tests', () {
    setUp(() {
      Get.lazyPut(
        () => DeliveryCodeFormController(
          deliveriesRepository: DeliveriesRepository(
            apiClient: ApiClient(
              httpClient: Client(),
              storageRepository: StorageRepository(
                storageClient: const FlutterSecureStorage(),
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('Testing initial state', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const supplierButtonKey = Key('supplier_flow_button');

      // pump
      await tester.pumpWidget(createTestView(const DeliveryCodeFormView()));
      await tester.pump();

      // assert
      expect(
        find.text('delivery_code_form_header'.tr),
        findsOneWidget,
      );
      expect(
        find.text('delivery_code_form_subheader'.tr),
        findsOneWidget,
      );
      expect(find.text('delivery_code_input_label'.tr), findsOneWidget);
      expect(find.text('code_input_hint'.tr), findsOneWidget);
      expect(
        find.text("verify_code_button".tr),
        findsOneWidget,
      );
      expect(
        find.text('empty_delivery_code_input_error'.tr),
        findsNothing,
      );
      expect(
        find.text('invalid_delivery_code_input_error'.tr),
        findsNothing,
      );
      expect(
        tester.widget<LoadingButton>(find.byKey(submitButtonKey)).onPressed,
        isNull,
        reason: 'Expect initial submit button to be disabled',
      );
      expect(
        tester.widget<OutlinedButton>(find.byKey(supplierButtonKey)).onPressed,
        Get.find<DeliveryCodeFormController>().onSupplierPressed,
      );
    });

    testWidgets('Testing when invalid code', (WidgetTester tester) async {
      // when
      const submitButtonKey = Key('code_submit_button');
      const code = '1234';
      await tester.pumpWidget(createTestView(const DeliveryCodeFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('invalid_delivery_code_input_error'.tr),
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
      const code = 'ABC123';
      await tester.pumpWidget(createTestView(const DeliveryCodeFormView()));
      await tester.pump();

      // then
      await tester.enterText(find.byType(OutlinedTextField), code);
      await tester.pumpAndSettle();

      // assert
      expect(
        find.text('empty_delivery_code_input_error'.tr),
        findsNothing,
      );
      expect(
        find.text('código de entrega inválido'.tr),
        findsNothing,
      );
      expect(
        tester.widget<ElevatedButton>(find.byKey(submitButtonKey)).onPressed,
        Get.find<DeliveryCodeFormController>().submitForm,
        reason: 'Expect submit button to be enabled',
      );
    });
  });
}
