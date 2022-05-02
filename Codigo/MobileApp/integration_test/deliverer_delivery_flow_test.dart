import 'package:delivery_manager/app/widgets/outlined_text_field.dart';
import 'package:delivery_manager/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'utils/delivery_delivery.dart';
import 'utils/setup_delivery.dart';
import 'utils/sign_in_deliverer.dart';

Future<void> main() async {
  await dotenv.load();

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group(
    'E2E Test the deliverer delivery flow',
    () {
      testWidgets(
          'See delivery details and start it. Deliver 2 orders and register a problem for the third one, finishing the delivery',
          (WidgetTester tester) async {
        // when
        final delivery = await setupDelivery();

        // Initialize app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // sign in supplier
        await testSignInDeliverer(
            tester: tester, deliveryCode: delivery.accessCode!);
        await tester.pumpAndSettle();

        // deliver delivery
        await deliverDelivery(tester: tester, delivery: delivery);
      });

      testWidgets(
          'Completes delivery and tries to deliver it again, should show an error message',
          (WidgetTester tester) async {
        // when
        final delivery = await setupDelivery();

        // Initialize app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // sign in supplier
        await testSignInDeliverer(
            tester: tester, deliveryCode: delivery.accessCode!);
        await tester.pumpAndSettle();

        // deliver delivery
        await deliverDelivery(tester: tester, delivery: delivery);

        // try to sign in again
        expect(find.byKey(const Key('code_submit_button')), findsOneWidget);
        await tester.enterText(
            find.byType(OutlinedTextField), delivery.accessCode!);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('code_submit_button')));
        await tester.pumpAndSettle();
        expect(
            find.text('invalid_delivery_code_input_error'.tr), findsOneWidget);
      });

      testWidgets('Delivers two deliveries at once',
          (WidgetTester tester) async {
        // when
        var delivery = await setupDelivery();

        // Initialize app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Delivering first one
        await testSignInDeliverer(
            tester: tester, deliveryCode: delivery.accessCode!);
        await tester.pumpAndSettle();
        await deliverDelivery(tester: tester, delivery: delivery);
        await tester.pumpAndSettle();

        // Generate a new delivery
        delivery = await setupDelivery();

        // Delivering second one
        await testSignInDeliverer(
            tester: tester, deliveryCode: delivery.accessCode!);
        await tester.pumpAndSettle();
        await deliverDelivery(tester: tester, delivery: delivery);
      });

      testWidgets('See delivery details and cancel it.',
          (WidgetTester tester) async {
        // when
        final delivery = await setupDelivery();

        // Initialize app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // sign in supplier
        await testSignInDeliverer(
            tester: tester, deliveryCode: delivery.accessCode!);
        await tester.pumpAndSettle();

        // check if the delivery details are showing, including list of products and orders
        expect(find.text(delivery.name!), findsOneWidget);
        expect(
          find.text(
            'delivery_initial_address'.tr.replaceAll(
                  ':address',
                  delivery.orders![0].shippingAddress.formatted,
                ),
          ),
          findsOneWidget,
        );
        expect(find.byType(GoogleMap), findsOneWidget);
        expect(find.text('start_delivery'.tr), findsOneWidget);
        expect(find.text('cancel_delivery'.tr), findsOneWidget);
        expect(find.text('products'.tr), findsOneWidget);
        expect(find.text('orders'.tr), findsOneWidget);
        expect(
          find.text(delivery.orders![0].orderProducts[0].name),
          findsOneWidget,
        );

        // click on the orders tab and expect all orders to be shown
        await tester.tap(find.text('orders'.tr));
        await tester.pumpAndSettle();
        expect(
          find.text(delivery.orders![0].buyerName),
          findsOneWidget,
        );

        // click on cancel button and check if dialog appear
        await tester.tap(find.text('cancel_delivery'.tr));
        await tester.pumpAndSettle();
        expect(find.text('cancel_delivery_dialog_title'.tr), findsOneWidget);

        // tap confirm button and check if returned to login screen
        await tester.tap(find.text('confirm'.tr));
        await tester.pumpAndSettle();
        expect(find.text('delivery_code_form_header'.tr), findsOneWidget);
      });
    },
    skip: true,
  );
}
