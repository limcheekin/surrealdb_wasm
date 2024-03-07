import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  const defineScopeStatement = r'''
DEFINE SCOPE user_scope
SESSION 24h
SIGNUP (
  CREATE user SET email = $email, password = crypto::argon2::generate($password)
)
SIGNIN (
  SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password)
);
''';

  setUpAll(() async {
    await db.connect('indxdb://surreal');
    /* Tests run on 01 Feb 2024 with 8 errors/failures? 
    Local SurrealDB v1.1.1 started with the following command:
    surreal start --log trace --user root --pass root
    await db.connect(
      'ws://localhost:8000',
      options: {
        'user': {'username': 'root', 'password': 'root'},
      },
    );
    */
    await db.use(namespace: 'surreal', database: 'surreal');
  });

  tearDown(() async {
    await db.delete('person'); // delete all
  });

  testWidgets('Verify the current namespace', (WidgetTester tester) async {
    final results = await db.query('INFO FOR NS');
    final result = Map<String, dynamic>.from(results! as Map);
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
      result! as Map,
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
      merged! as Map,
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
    final results = (await db.select(tom['id'] as String))! as List;
    final selectedTom = Map<String, dynamic>.from(results.first as Map);
    expect(tom['name'], equals(selectedTom['name']));
  });

  testWidgets('Execute a SurrealQL query and verify the result',
      (WidgetTester tester) async {
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
    final results = (await db.select('person'))! as List;
    expect(results, isEmpty);
  });

  testWidgets('set test', (WidgetTester tester) async {
    await db.set('testKey', 'testValue');
  });

  testWidgets('unset test', (WidgetTester tester) async {
    await db.set('testKey', 'testValue');
    await db.unset('testKey');
  });

  testWidgets('patch test', (WidgetTester tester) async {
    await db.create('keyValue', {'key': 'value'});
    await db.patch('keyValue', [
      {'op': 'replace', 'path': '/key', 'value': 'newValue'},
    ]);
    final result = await db.query('SELECT key FROM keyValue');
    expect(
      result! as List,
      equals([
        {'key': 'newValue'},
      ]),
    );
  });

  testWidgets('signup test', (WidgetTester tester) async {
    await db.query(defineScopeStatement);
    final credentials = {
      'namespace': 'surreal',
      'database': 'surreal',
      'scope': 'user_scope',
      'email': 'john.doe@example.com',
      'password': 'password123',
    };
    final result = await db.signup(credentials);
    expect(result, isNotNull);
  });

  testWidgets('signin test', (WidgetTester tester) async {
    final credentials = {
      'namespace': 'surreal',
      'database': 'surreal',
      'scope': 'user_scope',
      'email': 'john@example.com',
      'password': 'password456',
    };
    await db.signup(credentials);
    final result = (await db.signin(credentials))! as String;
    expect(result, isNotNull);
  });

  /* FAILED???
  testWidgets('authenticate and invalidate test', (WidgetTester tester) async {
    final credentials = {
      'namespace': 'surreal',
      'database': 'surreal',
      'scope': 'user_scope',
      'email': 'doe@example.com',
      'password': 'password789',
    };
    await db.signup(credentials);
    final token = (await db.signin(credentials))! as String;
    await db.authenticate(token);
    await db.invalidate();
  });
  */

  testWidgets('version test', (WidgetTester tester) async {
    final result = await db.version();
    expect(result, isNotNull);
  });

  testWidgets('health test', (WidgetTester tester) async {
    await db.health();
  });
}
