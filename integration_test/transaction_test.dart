// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_js/surrealdb_js.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main({bool wasm = false}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = SurrealWasm.getInstance();

  setUpAll(() async {
    if (wasm) {
      await db.connect('indxdb://test');
      await db.use(namespace: 'surreal', database: 'surreal');
    } else {
      await db.connect('http://127.0.0.1:8000/rpc');
      await db.use(namespace: 'surreal', database: 'surreal');
      await db.signin({'username': 'root', 'password': 'root'});
    }
  });

  group('db.transaction()', () {
    testWidgets('Transaction executes successfully',
        (WidgetTester tester) async {
      await db.transaction((txn) async {
        txn.query('DEFINE TABLE test SCHEMAFULL;');
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
