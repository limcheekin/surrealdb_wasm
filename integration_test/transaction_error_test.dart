import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_js/surrealdb_js.dart';

// REF: https://github.com/dart-lang/sdk/issues/55496
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  group('db.transaction()', () {
    testWidgets('should throw error message: Connection error',
        (WidgetTester tester) async {
      expect(
        () async {
          final newDb = Surreal();
          await newDb.transaction(
            (txn) async {
              txn.query('CREATE account:one SET balance = 135605.16;');
            },
          );
        },
        throwsA('() => Future<Null>'),
      );
    });

    testWidgets('should throw error message: Specify a namespace to use',
        (WidgetTester tester) async {
      expect(
        () async {
          final newDb = Surreal();
          await newDb.connect('mem://');
          await newDb.transaction(
            (txn) async {
              txn.query('CREATE account:one SET balance = 135605.16;');
            },
          );
        },
        throwsA(isA<Error>()),
      );
    });

    testWidgets('Transaction with invalid SQL throws exception',
        (WidgetTester tester) async {
      expect(
        () async {
          await db.transaction((txn) async {
            txn.query(
              'CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT);',
            );
          });
        },
        throwsA(isA<Error>()),
      );
    });
  });
}
