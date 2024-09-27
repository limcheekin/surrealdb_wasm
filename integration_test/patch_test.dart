import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
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
  tearDown(() async {
    await db.delete('keyValue'); // delete all
  });

  /* 
  The following test will fail when execute with other tests,
  but passed when run on it own???
  */
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
}
