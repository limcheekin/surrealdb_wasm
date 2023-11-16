import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  setUpAll(() async {
    await db.connect('mem://');
    await db.use(ns: 'surreal', db: 'surreal');
  });

  testWidgets('should throw Connection uninitialised',
      (WidgetTester tester) async {
    expect(
      () async {
        final newDb = Surreal();
        await newDb.transaction(
          (txn) {
            txn.query('CREATE account:one SET balance = 135605.16;');
          },
        );
      },
      throwsA(
        isA<Exception>().having(
          (e) => e,
          'message',
          'Connection uninitialised',
        ),
      ),
    );
  });
}
