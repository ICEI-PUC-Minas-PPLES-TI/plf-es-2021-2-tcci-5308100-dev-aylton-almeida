import 'dart:io';

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  await Process.run('applesimutils', [
    '--bundle',
    '"com.example.deliveryManager"',
    ' --setPermissions',
    'location=always'
  ]);
  await integrationDriver();
}
