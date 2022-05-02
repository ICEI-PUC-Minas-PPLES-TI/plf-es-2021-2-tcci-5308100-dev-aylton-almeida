import 'package:delivery_manager/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/sign_in_deliverer.dart';

Future<void> main() async {
  await dotenv.load();

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group(
    'E2E Test the deliverer auth flow',
    () {
      testWidgets('Sign in successfully as a deliverer',
          (WidgetTester tester) async {
        // Initialize app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Test sign in deliverer
        await testSignInDeliverer(tester: tester);
      });
    },
  );
}
