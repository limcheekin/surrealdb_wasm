// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  setUp(() async {
    print('setUp()');
    await db.connect('indxdb://surreal');
    await db.use(ns: 'surreal', db: 'surreal');
  });

  tearDown(() {
    //db.dispose();
  });

  testWidgets('Verify the current namespace', (WidgetTester tester) async {
    print('db.query("INFO FOR NS")');
    final results = await db.query('INFO FOR NS');
    final resultList = results! as List<Map<String, dynamic>>;
    expect(
      resultList.first['databases'],
      equals({'surreal': 'DEFINE DATABASE surreal'}),
    );
  });

  testWidgets('Create a record and verify its creation',
      (WidgetTester tester) async {
    print("db.create('person', data)");
    final data = {
      'name': 'Tobie',
      'settings': {'active': true, 'marketing': true},
    };
    final result = await db.create('person', data);
    final tobie = Map<String, dynamic>.from(result! as Map);
    expect(tobie['id'], isNotNull);
  });

  testWidgets('Update a record and verify the update',
      (WidgetTester tester) async {
    print("db.update('person', data)");
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    tom['name'] = 'Tom John';
    tom.remove('settings');

    final updated = await db.update('person', tom);
    final updatedTom = Map<String, dynamic>.from(updated! as Map);
    expect(updatedTom['name'], equals(tom['name']));
    expect(updatedTom['settings'], isNull);
  });

  testWidgets('Merge data into a record and verify the merge',
      (WidgetTester tester) async {
    print("db.merge('person', data)");
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    final mergeData = {
      'settings': {'marketing': true},
    };
    final merged = await db.merge('person:${tom['id']}', mergeData);
    final mergedTom = Map<String, dynamic>.from(merged! as Map);
    final settings = mergedTom['settings'] as Map<String, dynamic>;
    expect(settings['active'], equals(true));
    expect(settings['marketing'], equals(true));
  });

  testWidgets('Select a specific record and verify the selection',
      (WidgetTester tester) async {
    print("db.select('person')");
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    final result = await db.select('person:${tom['id']}');
    final selectedTom = Map<String, dynamic>.from(result! as Map);
    expect(tom['name'], equals(selectedTom['name']));
  });

  testWidgets('Execute a SurrealQL query and verify the result',
      (WidgetTester tester) async {
    print('db.query()');
    await db.delete('person'); // delete all
    await db.create(
      'person',
      {
        'name': 'Tobie',
        'settings': {'active': true, 'marketing': true},
      },
    );
    await db.create(
      'person',
      {
        'name': 'Tom',
        'settings': {'active': true, 'marketing': false},
      },
    );
    const sql = 'SELECT * FROM person';
    final result = await db.query(sql);
    final people = result! as List<Map<String, dynamic>>;
    expect(people.length, equals(2));
  });

  testWidgets('Delete a specific record and verify the deletion',
      (WidgetTester tester) async {
    print('db.delete()');
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    await db.delete('person:${tom['id']}');
    final result = await db.select('person:${tom['id']}');
    expect(result, isNull);
  });

  testWidgets('Failed test example', (WidgetTester tester) async {
    expect(2 + 2, equals(5));
  });
}
