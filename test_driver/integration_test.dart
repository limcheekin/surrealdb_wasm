import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() async {
  /// Repports are generated on given path, once all tested passed,
  integration_test_driver.testOutputsDirectory = 'integration_test/reports';
  await integration_test_driver.integrationDriver(
    timeout: const Duration(minutes: 3),
  );
}
