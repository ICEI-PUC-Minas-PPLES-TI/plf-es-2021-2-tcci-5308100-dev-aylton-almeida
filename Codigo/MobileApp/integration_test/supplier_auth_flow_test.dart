import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:delivery_manager/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

Future<void> main() async {
  await dotenv.load();

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('E2E Test the supplier auth flow', () {
    testWidgets('Sign in successfully as a supplier',
        (WidgetTester tester) async {
      print(dotenv.env['API_URL']);

      // Initialize app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // when
      const validPhone = '5531999385992';

      // Find I'm a partner button and press it
      expect(find.text('trela_partner_button'.tr), findsOneWidget);
      await tester.tap(find.byKey(const Key('supplier_flow_button')));

      await tester.pumpAndSettle();

      // Check if user was redirected to the phone form page
      expect(find.text('phone_form_sub_header'.tr), findsOneWidget);
      expect(find.text('phone_input_label'.tr), findsOneWidget);
      expect(find.byKey(const Key('phone_submit_button')), findsOneWidget);

      // Enter a valid phone and check if the next page appears
      await tester.enterText(find.byType(OutlinedTextField), validPhone);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('phone_submit_button')));

      await tester.pumpAndSettle();

      // Find the code field, fill it and go to next step
      expect(find.text('confirmation_code_input_label'.tr), findsOneWidget);
      await tester.enterText(find.byType(OutlinedTextField), '12332');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('code_submit_button')));

      await tester.pumpAndSettle();

      // Find the delivery list title, meaning the supplier is authenticated
      expect(find.text('delivery_list_title'.tr), findsOneWidget);
    });
  });
}
