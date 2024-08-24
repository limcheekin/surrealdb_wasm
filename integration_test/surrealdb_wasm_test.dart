import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main({bool wasm = false}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = SurrealWasmMutex.getInstance();
  //Tests run with local SurrealDB instance started with the command below:
  //surreal start memory --log trace --allow-all --auth --user root --pass root
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

  tearDown(() async {
    try {
      await db.delete('person'); // delete all
    } catch (_) {}
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
    expect(doc['created'], equals(DateTime.parse(created)));

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
    expect(mergedDoc['created'], equals(DateTime.parse(mergedDate)));
  });

  testWidgets('Create a record with bindings param',
      (WidgetTester tester) async {
    const sql = '''
DEFINE TABLE bindings SCHEMALESS;
DEFINE FIELD file ON bindings TYPE string;
''';
    await db.query(sql);
    const text = 'Hello World!';
    final data = {
      'content': {
        'file': text,
      },
    };
    var result = await db.query(
      r'CREATE ONLY bindings CONTENT $content',
      bindings: data,
    );
    final doc = Map<String, dynamic>.from(
      result! as Map,
    );

    expect(doc['id'], isNotNull);
    expect(doc['file'], equals(text));

    result = await db.select(doc['id'].toString());
    final selectedDoc = Map<String, dynamic>.from(result! as Map);
    expect(selectedDoc['file'], equals(text));
  });

  testWidgets('Create a record with bytes type field and change it',
      (WidgetTester tester) async {
    const sql = '''
DEFINE TABLE documents SCHEMALESS;
DEFINE FIELD file ON documents TYPE bytes;
''';
    await db.query(sql);
    const text = 'Hello World!';
    final file = utf8.encode(text);
    final data = {
      'file': file,
    };
    var result = await db.query(
      r'CREATE ONLY documents CONTENT $content',
      bindings: {'content': data},
    );
    final doc = Map<String, dynamic>.from(
      result! as Map,
    );

    expect(doc['id'], isNotNull);
    var resultFile = (doc['file'] as ByteBuffer).asUint8List();
    expect(resultFile, equals(file));

    result = await db.select(doc['id'].toString());
    final selectedDoc = Map<String, dynamic>.from(result! as Map);
    resultFile = (selectedDoc['file'] as ByteBuffer).asUint8List();
    expect(resultFile, equals(file));
    // ignore: avoid_dynamic_calls
    expect(selectedDoc['file'].runtimeType, equals(ByteBuffer));

    const mergeText = 'Hello Magic World!';
    final mergeFile = utf8.encode(mergeText);
    final mergeData = {
      'file': mergeFile,
    };
    final merged = await db.query(
      'UPDATE ONLY ${doc['id']} MERGE \$content',
      bindings: {'content': mergeData},
    );
    final mergedDoc = Map<String, dynamic>.from(
      merged! as Map,
    );
    resultFile = (mergedDoc['file'] as ByteBuffer).asUint8List();
    expect(resultFile, equals(mergeFile));
    expect(utf8.decode(resultFile), equals(mergeText));
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
    final updated = await db.update(tom.remove('id').toString(), tom);
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
    final merged = await db.merge(tom['id'].toString(), mergeData);
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
    final result = await db.select(tom['id'].toString());
    final selectedTom = Map<String, dynamic>.from(result! as Map);
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
    final id = tom['id'].toString();
    await db.delete(id);
    final result = await db.select('person');
    expect(result, isNull);
  });

  testWidgets('let test', (WidgetTester tester) async {
    await db.let('testKey', 'testValue');
  });

  testWidgets('unset test', (WidgetTester tester) async {
    await db.let('testKey', 'testValue');
    await db.unset('testKey');
  });

  testWidgets('version test', (WidgetTester tester) async {
    final result = await db.version();
    expect(result, isNotNull);
  });

  testWidgets('should throw ConnectionUnavailable after close()',
      (WidgetTester tester) async {
    final result = await db.version();
    expect(result, isNotNull);
    await db.close();
    expect(
      () async => db.version(),
      throwsA(
        predicate((e) => e.toString().contains('ConnectionUnavailable')),
      ),
    );
  });
}
