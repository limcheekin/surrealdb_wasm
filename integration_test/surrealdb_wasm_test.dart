import 'dart:convert';

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

  testWidgets('Create a record with datetime field and change it',
      (WidgetTester tester) async {
    const sql = '''
DEFINE TABLE document SCHEMALESS;
DEFINE FIELD content ON document TYPE option<string>;
DEFINE FIELD created ON document TYPE datetime;
''';
    await db.query(sql);
    const created = '2023-10-31T03:19:16.601Z';
    final data = {
      'content': 'doc 1',
      'created': created,
    };
    final result =
        await db.query('CREATE ONLY document CONTENT ${jsonEncode(data)}');
    final doc = Map<String, dynamic>.from(
      (result! as List).first as Map,
    );
    expect(doc['id'], isNotNull);
    expect(doc['created'], equals(created));

    const mergedDate = '2023-11-01T03:19:16.601Z';
    final mergeData = {
      'created': mergedDate,
    };
    final merged = await db.query(
      'UPDATE ONLY ${doc['id']} MERGE ${jsonEncode(mergeData)}',
    );
    final mergedDoc = Map<String, dynamic>.from(
      (merged! as List).first as Map,
    );
    expect(mergedDoc['created'], equals(mergedDate));
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
  // Integration tests for set method
  testWidgets('set method test', (WidgetTester tester) async {
    await db.set('testKey', 'testValue');
    final result = await db.query('SELECT testKey FROM <table>');
    expect(result, equals('testValue'));
  });

  // Integration tests for unset method
  testWidgets('unset method test', (WidgetTester tester) async {
    await db.set('testKey', 'testValue');
    await db.unset('testKey');
    final result = await db.query('SELECT testKey FROM <table>');
    expect(result, isNull);
  });

  // Integration tests for signup method
  testWidgets('signup method test', (WidgetTester tester) async {
    final credentials = {'user': 'testUser', 'pass': 'testPass'};
    final result = await db.signup(credentials);
    expect(result, contains('token'));
  });

  // Integration tests for signin method
  testWidgets('signin method test', (WidgetTester tester) async {
    final credentials = {'user': 'testUser', 'pass': 'testPass'};
    await db.signup(credentials);
    final result = (await db.signin(credentials))! as String;
    expect(result, contains('token'));
  });

  // Integration tests for invalidate method
  testWidgets('invalidate method test', (WidgetTester tester) async {
    final credentials = {'user': 'testUser', 'pass': 'testPass'};
    await db.signup(credentials);
    final token = (await db.signin(credentials))! as String;
    await db.authenticate(token);
    await db.invalidate();
    final result = await db.query('INFO FOR USER');
    expect(result, isNull);
  });

  // Integration tests for authenticate method
  testWidgets('authenticate method test', (WidgetTester tester) async {
    final credentials = {'user': 'testUser', 'pass': 'testPass'};
    await db.signup(credentials);
    final token = (await db.signin(credentials))! as String;
    await db.authenticate(token);
    final result = await db.query('INFO FOR USER');
    expect(result, isNotNull);
  });

  // Integration tests for patch method
  testWidgets('patch method test', (WidgetTester tester) async {
    await db.create('<table>', {'key': 'value'});
    await db.patch('<table>', [
      {'op': 'replace', 'path': '/key', 'value': 'newValue'},
    ]);
    final result = await db.query('SELECT key FROM <table>');
    expect(result, equals('newValue'));
  });

  // Integration tests for version method
  testWidgets('version method test', (WidgetTester tester) async {
    final result = await db.version();
    expect(result, isNotNull);
  });

  // Integration tests for health method
  testWidgets('health method test', (WidgetTester tester) async {
    await db.health();
    // Assuming health check passes if no exception is thrown
    expect(true, isTrue);
  });
}
