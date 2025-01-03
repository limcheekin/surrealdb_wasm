import 'package:flutter/material.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';
import 'package:flutter_console_widget/flutter_console.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SurrealDB WebAssembly(WASM) Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterConsoleController controller = FlutterConsoleController();
  final db = SurrealWasm.getInstance();
  static const commandSymbol = '>';

  Future<dynamic> execute(Function function, [String? message]) async {
    controller.print(
      message: '$commandSymbol $message',
      endline: false,
    );
    dynamic result;
    try {
      result = await function();
      controller.print(
        message: ' ✅',
        endline: true,
      );
      if (result != null) {
        debugPrint('homepage: result $result');
        if (result is Iterable) {
          if (result.isNotEmpty) {
            if (result.first is List) {
              // nested list for multiple statements
              if (result
                  .reduce((value, element) => value + element)
                  .isNotEmpty) {
                controller.print(
                  message: result.toString(),
                  endline: true,
                );
              }
            } else {
              controller.print(
                message: result.toString(),
                endline: true,
              );
            }
          }
        } else {
          controller.print(
            message: result.toString(),
            endline: true,
          );
        }
      }
    } catch (error, stackTrace) {
      controller.print(
        message: ' ❎ $error',
        endline: true,
      );
      controller.print(
        message: stackTrace.toString(),
        endline: true,
      );
    }
    return result;
  }

  Future<void> executeSurrealDbCodes() async {
    await execute(
      () => db.connect('indxdb://surreal'),
      'db.connect()',
    );

    await execute(
      () => db.version(),
      'db.version',
    );

    await execute(
      () => db.use(namespace: 'surreal', database: 'surreal'),
      'db.use()',
    );

    await execute(
      () {
        return db.query('INFO FOR NS');
      },
      'db.query() ns',
    );

    final created = await execute(
      () {
        return db.create(
          'person',
          {
            'title': 'CTO',
            'name': {
              'first': 'Tom',
              'last': 'Jerry',
            },
            'marketing': true,
          },
        );
      },
      'db.create()',
    );

    final id = created['id'].toString();
    await execute(
      () {
        return db.update(
          id,
          {
            'title': 'CTO',
            'name': {
              'first': 'Tom',
              'last': 'John',
            },
          },
        );
      },
      'db.update()',
    );

    await execute(
      () => db.merge(
        id,
        {
          'marketing': false,
        },
      ),
      'db.merge()',
    );

    await execute(
      () => db.patch(
        id,
        [
          {'op': 'replace', 'path': '/status', 'value': 'completed'},
        ],
      ),
      'db.patch()',
    );

    // batch inserts
    await execute(
      () {
        final people = [
          {
            'title': 'CEO',
            'name': {
              'first': 'John',
              'last': 'Dow',
            },
            'marketing': true,
          },
          {
            'title': 'COO',
            'name': {
              'first': 'Gavin',
              'last': 'Law',
            },
            'marketing': true,
          },
        ];
        final result = db.query(
          'INSERT INTO person \$people',
          bindings: {
            'people': people,
          },
        );
        return result;
      },
      'db.query() batch inserts',
    );

    await execute(
      () => db.select('person'),
      'db.select()',
    );

    await execute(
      () {
        final groups = db.query(
          'SELECT marketing, count() FROM type::table(\$table) GROUP BY marketing',
          bindings: {
            'table': 'person',
          },
        );
        return groups;
      },
      'db.query() grouping',
    );

    await execute(
      () => db.delete('person'),
      'db.delete()',
    );

    await execute(
        () => db.transaction(
              (txn) async {
                txn.query('DEFINE TABLE test SCHEMAFULL;');
                txn.query('DEFINE FIELD name ON test TYPE string;');
                txn.query(
                  r'CREATE test SET name = $name;',
                  bindings: {'name': 'John'},
                );
              },
            ),
        'db.transaction()');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await executeSurrealDbCodes();
      echoLoop();
    });
  }

  void echoLoop() {
    controller.scan().then((value) {
      execute(
        () => db.query(value),
        value,
      );
      controller.focusNode.requestFocus();
      echoLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SurrealDB WebAssembly(WASM) Example'),
      ),
      body: FlutterConsole(
        controller: controller,
        height: size.height,
        width: size.width,
      ),
    );
  }
}
