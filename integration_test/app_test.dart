import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  setUpAll(() async {
    await db.connect('indxdb://surreal');
    await db.use(ns: 'surreal', db: 'surreal');
  });

  tearDown(() {
    //db.dispose();
  });

  testWidgets('Verify the current namespace', (WidgetTester tester) async {
    final results = await db.query('INFO FOR NS');
    final resultList = results! as List;
    final result = Map<String, dynamic>.from(resultList.first! as Map);
    expect(
      result['databases'],
      isEmpty, // nothing had been created
    );
  });

  testWidgets('Create a record and verify its creation',
      (WidgetTester tester) async {
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
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    tom['name'] = 'Tom John';
    tom.remove('settings');

    final updated = await db.update(tom.remove('id') as String, tom);
    final updatedTom = Map<String, dynamic>.from(updated! as Map);
    expect(updatedTom['name'], equals(tom['name']));
    expect(updatedTom['settings'], isNull);
  });

  testWidgets('Merge data into a record and verify the merge',
      (WidgetTester tester) async {
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    final mergeData = {
      'settings': {'marketing': true},
    };
    final merged = await db.merge(tom['id'] as String, mergeData);
    final mergedTom = Map<String, dynamic>.from(merged! as Map);
    final settings = Map<String, dynamic>.from(mergedTom['settings'] as Map);
    expect(settings['active'], equals(true));
    expect(settings['marketing'], equals(true));
  });

  testWidgets('Select a specific record and verify the selection',
      (WidgetTester tester) async {
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    final result = await db.select(tom['id'] as String);
    final selectedTom = Map<String, dynamic>.from(result! as Map);
    expect(tom['name'], equals(selectedTom['name']));
  });

  testWidgets('Execute a SurrealQL query and verify the result',
      (WidgetTester tester) async {
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
    final results = await db.query(sql);
    final people = results! as List;
    expect(people.length, equals(2));
  });

  testWidgets('Delete a specific record and verify the deletion',
      (WidgetTester tester) async {
    final data = {
      'name': 'Tom',
      'settings': {'active': true, 'marketing': false},
    };
    final created = await db.create('person', data);
    final tom = Map<String, dynamic>.from(created! as Map);
    final id = tom['id'] as String;
    await db.delete(id);
    final result = await db.select(id);
    expect(result, isNull);
  });
}
