// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  setUpAll(() async {
    await db.connect('mem://');
    await db.use(namespace: 'surreal', database: 'surreal');
  });
  group('db.transaction()', () {
    testWidgets('should throw error message: Connection uninitialised',
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
        throwsA(
          predicate((e) => e is String && e == 'Connection uninitialised'),
        ),
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
        throwsA(
          predicate((e) => e is String && e == 'Specify a namespace to use'),
        ),
      );
    });

    testWidgets('Transaction executes successfully',
        (WidgetTester tester) async {
      await db.transaction((txn) async {
        txn.query('DEFINE TABLE test SCHEMAFULL;');
        txn.query('DEFINE FIELD id ON test TYPE record;');
        txn.query('DEFINE FIELD name ON test TYPE string;');
        txn.query(
          r'CREATE test SET name = $name;',
          bindings: {'name': 'John'},
        );
      });

      final result = await db.query('SELECT * FROM test;');
      expect(result, isNotEmpty);
      final test = Map<String, dynamic>.from(
        (result! as List).first as Map,
      );
      expect(test['name'], equals('John'));
      await db.delete('test'); // clean up
    });

    testWidgets('Transaction cancellation prevents execution',
        (WidgetTester tester) async {
      const somethingWrong = true;
      final transactionResult = await db.transaction((txn) async {
        txn.query(
          r'CREATE test SET name = $name;',
          bindings: {'name': 'John'},
        );
        if (somethingWrong) {
          txn.cancel();
        }
      });
      expect(
        transactionResult,
        equals('Transaction has been canceled by user.'),
      );
      final result = await db.query('SELECT * FROM test;');
      expect(result, isEmpty);
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
        throwsA(isA<String>()),
      );
    });

    test('Transaction with empty SQL does not execute', () async {
      final result = await db.transaction((txn) async {
        txn.query('');
      });

      expect(result, isNull);
    });

    test('Concurrent Transactions: Multiple transactions execute concurrently',
        () async {
      final result1 = db.transaction((txn) async {
        await Future<void>.delayed(
          const Duration(milliseconds: 100),
        ); // Simulating a transaction taking time
        txn.query(
          r'CREATE test1 SET name = $name;',
          bindings: {'name': 'John'},
        );
      });

      final result2 = db.transaction((txn) async {
        await Future<void>.delayed(
          const Duration(milliseconds: 50),
        ); // Simulating a transaction taking time
        txn.query(
          r'CREATE test2 SET name = $name;',
          bindings: {'name': 'Alice'},
        );
      });

      await Future.wait([result1, result2]);
      await db.delete('test1');
      await db.delete('test2');
      expect(result1, isNotNull);
      expect(result2, isNotNull);
    });

    test('Nested Transactions: Handles nested transactions correctly',
        () async {
      final result = await db.transaction((outerTxn) async {
        outerTxn.query(
          r'CREATE test1 SET name = $name;',
          bindings: {'name': 'John'},
        );
        await db.transaction((innerTxn) async {
          innerTxn.query(
            r'CREATE test2 SET name = $name;',
            bindings: {'name': 'Alice'},
          );
        });

        final result = await db.query('SELECT * FROM test2');
        // Ensure the data was inserted correctly in the nested transaction
        expect(result, isNotEmpty);
        final test = Map<String, dynamic>.from(
          (result! as List).first as Map,
        );
        expect(test['name'], equals('Alice'));
      });

      expect(result, isNotNull);
    });

    test('Transaction Timeout: Handles transactions that take too long',
        () async {
      // Define a transaction that takes longer than the timeout
      Future<void> longRunningTransaction(Transaction txn) async {
        await Future<void>.delayed(
          const Duration(seconds: 2),
        ); // Simulate a long-running transaction
      }

      // Expect a TimeoutException to be thrown during the transaction
      expect(
        () async {
          await db.transaction(
            longRunningTransaction,
            timeout: const Duration(seconds: 1),
          );
        },
        throwsA(isA<TimeoutException>()),
      );
    });
  });

  group('Transaction', () {
    testWidgets('Transaction generates unique Id.',
        (WidgetTester tester) async {
      final txn = Transaction(db);
      expect(txn.id, isNotNull);
      expect(txn.id.length, equals(19));
      expect(int.tryParse(txn.id), isNotNull);
    });

    testWidgets('Transaction can be canceled', (WidgetTester tester) async {
      final txn = Transaction(db);
      txn.cancel();
      expect(txn.isCancel, isTrue);
    });

    testWidgets('Query parameterization works as expected',
        (WidgetTester tester) async {
      final txn = Transaction(db);
      txn.query(
        r'INSERT INTO table (name, age) VALUES ($name, $age)',
        bindings: {'name': 'John', 'age': 25},
      );
      expect(txn.buffer.toString(), contains('"John", 25'));

      txn.query(r'INSERT INTO table (name, age) VALUES ($name, $age)');
      expect(
        txn.buffer.toString(),
        contains(r'INSERT INTO table (name, age) VALUES ($name, $age)'),
      );
    });
  });
}
