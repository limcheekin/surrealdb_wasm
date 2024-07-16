import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:surrealdb_js/surrealdb_js.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = Surreal();

  final logger = Logger();

  const defineScopeStatement = r'''
DEFINE SCOPE user_scope
SESSION 24h
SIGNUP (
  CREATE user SET email = $email, password = crypto::argon2::generate($password)
)
SIGNIN (
  SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password)
);
DEFINE TABLE user PERMISSIONS FOR select WHERE id = $auth;
''';

  //Tests run with local SurrealDB instance started with the command below:
  //surreal start memory --log trace --allow-all --auth --user root --pass root
  setUpAll(() async {
    await db.connect('http://127.0.0.1:8000/rpc');
    await db.use(namespace: 'surreal', database: 'surreal');
    await db.signin({'username': 'root', 'password': 'root'});
  });

  tearDown(() async {
    await db.delete('keyValue'); // delete all
  });

  /* 
  The following test will fail when execute with other tests,
  but passed when run on it own???
  */

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
    final result = await db.signin(credentials);
    logger.i('signin result $result');
    expect(result, isNotNull);
  });

  testWidgets('info test', (WidgetTester tester) async {
    final surreal = Surreal();
    await surreal.connect('http://127.0.0.1:8000/rpc');
    await surreal.use(namespace: 'surreal', database: 'surreal');
    final credentials = {
      'namespace': 'surreal',
      'database': 'surreal',
      'scope': 'user_scope',
      'email': 'info@example.com',
      'password': 'password456',
    };
    await surreal.signup(credentials);
    await surreal.signin(credentials);
    final info = await surreal.info();
    logger.i('info $info');
    await surreal.close();
    expect(info, isNotNull);
  });

  testWidgets('authenticate and invalidate test', (WidgetTester tester) async {
    final credentials = {
      'namespace': 'surreal',
      'database': 'surreal',
      'scope': 'user_scope',
      'email': 'doe@example.com',
      'password': 'password789',
    };
    await db.signup(credentials);
    final token = await db.signin(credentials);
    logger.i('token $token');
    await db.authenticate(token.toString());
    await db.invalidate();
  });
}
