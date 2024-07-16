import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:surrealdb_js/surrealdb_js.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();
  //Tests run with local SurrealDB instance started with the command below:
  //surreal start memory --log trace --allow-all --auth --user root --pass root
  setUpAll(() async {
    await db.connect('http://127.0.0.1:8000/rpc');
    await db.use(namespace: 'surreal', database: 'surreal');
    await db.signin({'username': 'root', 'password': 'root'});
  });

  /* 
  The following test will fail when execute with other tests,
  but passed when run on it own???
  */
  testWidgets('Verify the current namespace', (WidgetTester tester) async {
    final results = await db.query('INFO FOR NS');
    final result = Map<String, dynamic>.from(results! as Map);
    expect(
      result['databases'],
      isEmpty,
    );
  });
}
