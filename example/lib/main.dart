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

  Future<void> execute(Function function) async {
    String functionString = function.toString();
    controller.print(
      message: functionString.substring(
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
      controller.print(
        message: "👀 $result",
        endline: true,
      );
    }
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

      await execute(
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
    });
  }

  void echoLoop() {
    controller.scan().then((value) {
      controller.print(message: value, endline: true);
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
