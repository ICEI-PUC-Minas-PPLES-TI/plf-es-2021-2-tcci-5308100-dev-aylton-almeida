import 'dart:convert';

import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';
import 'utils/sign_in_deliverer.dart';

Future<void> main() async {
  await dotenv.load();

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('E2E Test the deliverer delivery flow', () {
    final _apiClient = Client();
    final baseUrl = dotenv.env['API_URL'];

    late Delivery delivery;

    setUp(() async {
      final response =
          await _apiClient.post(Uri.parse('$baseUrl/integration-setup'));

      if (response.statusCode != 200) {
        throw Exception('Failed request with error ${response.statusCode}');
      }

      final parsed_delivery = jsonDecode(response.body);
      delivery = Delivery.fromJson(parsed_delivery);
    });

    // testWidgets(
    //     'See delivery details and start it. Deliver 2 orders and register a problema for the third one, finishing the delivery',
    //     (WidgetTester tester) async {
    //   // Initialize app
    //   await tester.pumpWidget(const MyApp());
    //   await tester.pumpAndSettle();

    //   // sign in supplier
    //   await testSignInDeliverer(
    //       tester: tester, deliveryCode: delivery.accessCode!);
    //   await tester.pumpAndSettle();

    //   // check if the delivery details are showing, including list of products and orders
    //   expect(find.text('Compra em grupo Charlotte Fifield'), findsOneWidget);
    //   expect(
    //     find.text(
    //       'delivery_initial_address'.tr.replaceAll(
    //             ':address',
    //             delivery.orders![0].shippingAddress.formatted,
    //           ),
    //     ),
    //     findsOneWidget,
    //   );
    //   expect(
    //     find.byType(GoogleMap),
    //     findsOneWidget,
    //   );
    //   expect(find.text('start_delivery'.tr), findsOneWidget);
    //   expect(find.text('cancel_delivery'.tr), findsOneWidget);
    //   expect(find.text('products'.tr), findsOneWidget);
    //   expect(find.text('orders'.tr), findsOneWidget);
    //   expect(
    //     find.text(delivery.orders![0].orderProducts[0].name),
    //     findsOneWidget,
    //   );

    //   // click on the orders tab and expect all orders to be shown
    //   await tester.tap(find.text('orders'.tr));
    //   await tester.pumpAndSettle();
    //   for (final order in delivery.orders!) {
    //     await tester.tap(find.text('orders'.tr));
    //     await tester.pumpAndSettle();
    //     expect(
    //       find.text(order.buyerName),
    //       findsOneWidget,
    //     );
    //   }

    //   // click on cancel button and check if modal appear
    //   await tester.tap(find.text('cancel_delivery'.tr));
    //   await tester.pumpAndSettle();
    //   expect(find.text('cancel_delivery_modal_title'.tr), findsOneWidget);
    // });

    testWidgets('See delivery details and cancel it.',
        (WidgetTester tester) async {
      // Initialize app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // sign in supplier
      await testSignInDeliverer(
          tester: tester, deliveryCode: delivery.accessCode!);
      await tester.pumpAndSettle();

      // check if the delivery details are showing, including list of products and orders
      expect(find.text('Compra em grupo Charlotte Fifield'), findsOneWidget);
      expect(
        find.text(
          'delivery_initial_address'.tr.replaceAll(
                ':address',
                delivery.orders![0].shippingAddress.formatted,
              ),
        ),
        findsOneWidget,
      );
      expect(
        find.byType(GoogleMap),
        findsOneWidget,
      );
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
      for (final order in delivery.orders!) {
        await tester.tap(find.text('orders'.tr));
        await tester.pumpAndSettle();
        expect(
          find.text(order.buyerName),
          findsOneWidget,
        );
      }

      // click on cancel button and check if modal appear
      await tester.tap(find.text('cancel_delivery'.tr));
      await tester.pumpAndSettle();
      expect(find.text('cancel_delivery_modal_title'.tr), findsOneWidget);
    });
  });
}
