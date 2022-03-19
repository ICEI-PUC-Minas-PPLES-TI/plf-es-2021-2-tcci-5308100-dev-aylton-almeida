import 'package:delivery_manager/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'utils/sign_in_supplier.dart';

Future<void> main() async {
  await dotenv.load();

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('E2E Test the supplier delivery share flow', () {
    testWidgets(
        'See deliveries list, select first one, change to product tab and click the share button',
        (WidgetTester tester) async {
      // Initialize app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // sign in supplier
      await testSignInSupplier(tester);
      await tester.pumpAndSettle();

      // check if the deliveries list is shown and click on the first one
      expect(find.text('delivery_list_title'.tr), findsOneWidget);
      expect(find.text('Compra em grupo Charlotte Fifield'), findsOneWidget);
      expect(find.text('Entrega prevista: dia 17 às 10 horas'), findsWidgets);
      await tester.tap(find.text('Compra em grupo Charlotte Fifield'));
      await tester.pumpAndSettle();

      // assert the the delivery details page is shown with the products tab open
      expect(find.text('Compra em grupo Charlotte Fifield'), findsOneWidget);
      expect(find.text('Entrega prevista: dia 17 às 10 horas'), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
      expect(find.text('share_delivery_with_deliverer'.tr), findsOneWidget);
      expect(find.text('products'.tr), findsOneWidget);
      expect(find.text('orders'.tr), findsOneWidget);
      expect(find.text('Hambúrguer Angus Carapreta (Caixa C/2 Unidades)'),
          findsOneWidget);

      // click on the orders tab and expect first order to be shown
      await tester.tap(find.text('orders'.tr));
      await tester.pumpAndSettle();
      expect(find.text('Thomas Turner'), findsOneWidget);

      // click on share button and expect the share dialog to be shown
      await tester.tap(find.text('share_delivery_with_deliverer'.tr));
      await tester.pumpAndSettle();
    });
  });
}
