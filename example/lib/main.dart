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
      title: 'Flutter SurrealDB.wasm Demo',
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
  final db = Surreal();

  Future<dynamic> execute(Function function, [String? message]) async {
    String functionString = function.toString();
    controller.print(
      message: message ??
          functionString.substring(
            functionString.indexOf("db."),
          ),
      endline: false,
    );
    final result = await function();
    controller.print(
      message: " ✅",
      endline: true,
    );
    if (result != null) {
      debugPrint("homepage: result $result");
      controller.print(
        message: "👀 $result",
        endline: true,
      );
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await execute(
        () => db.connect("indxdb://surreal"),
      );

      await execute(
        () => db.use(ns: "surreal", db: "surreal"),
      );

      final created = await execute(
        () {
          return db.create(
            "person",
            {
              "title": "CTO",
              "name": {
                "first": "Tom",
                "last": "Jerry",
              },
              "marketing": true,
            },
          );
        },
      );

      await execute(
        () => db.merge(
          created['id'],
          {
            "marketing": false,
          },
        ),
      );

      await execute(
        () => db.select("person"),
      );

      await execute(
        () {
          final groups = db.query(
            "SELECT marketing, count() FROM type::table(\$table) GROUP BY marketing",
            {
              "table": "person",
            },
          );
          return groups;
        },
      );

      await execute(
        () => db.delete("person"),
      );
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
    echoLoop();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SurrealDB.wasm Demo'),
      ),
      body: FlutterConsole(
        controller: controller,
        height: size.height,
        width: size.width,
      ),
    );
  }
}
