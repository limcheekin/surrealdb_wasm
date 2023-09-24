import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:surrealdb_wasm/index.d.dart';

class NamespaceDatabase {
  final String ns;
  final String db;
  NamespaceDatabase({
    required this.ns,
    required this.db,
  });
}

class Name {
  String? first;
  String? last;

  Name({first, last});
}

class Person {
  String? title;
  Name? name;
  bool? marketing;
  String? identifier;

  Person({this.title, this.name, this.marketing, this.identifier});
}

final db = SurrealDB();

Future<void> connect(String endpoint, dynamic opts) async {
  debugPrint("db.connect()");
  await promiseToFuture(
    db.connect(
      endpoint,
      opts,
    ),
  );
  debugPrint("db.connect()");
}

Future<String> create(String resource, String data) async {
  debugPrint("db.create()");
  final result = await promiseToFuture(
    db.create(resource, data),
  );
  debugPrint("db.create() $result");
  return result;
}

/*

/// Allows assigning a function to be callable from `window.functionName()`
@JS('onfulfilled')
external set _onfulfilled(void Function(dynamic) f);

/// Allows calling the assigned function from Dart as well.
@JS()
external void onfulfilled(dynamic);
*/
void main() async {
  // Code that might throw an exception

  await connect("indxdb://surreal", null);
  //db.connect("indxdb://surreal", null);

  //debugPrint("db.health()");
  //db.health();
  debugPrint("db.use()");
  db.use(jsonEncode({"ns": "surreal", "db": "surreal"}));
  // Create a new person with a random id
  final created = await create(
    "person",
    jsonEncode({
      "title": "Founder & CEO",
      "name": {
        "first": "Tobie",
        "last": "Morgan Hitchcock",
      },
      "marketing": true,
    }),
  );

  debugPrint("created $created");

  /*created = await create(
      "person",
      jsonEncode({
        "title": "CTO",
        "name": {
          "first": "Tom",
          "last": "Jerry",
        },
        "marketing": true,
      }),
    );
    debugPrint("created 2 ${created.toString()}");

    
    // Update a person record with a specific id
    final updated = db.merge("person:jaime", {
      "marketing": true,
    });
    debugPrint("updated $updated");

    // Select all people records
    final people = db.select("person");
    debugPrint("people $people");

    // Perform a custom advanced query
    final groups = db.query(
        "SELECT marketing, count() FROM type::table(\$table) GROUP BY marketing",
        {
          "table": "person",
        });
    debugPrint("groups $groups");

    // Delete all people upto but not including Jaime
    final deleted = db.delete("person:..jaime");
    debugPrint("deleted $deleted");

    // Delete all people
    db.delete("person");

    // REF: https://surrealdb.com/docs/surrealql/functions/vector
    //		https://github.com/surrealdb/surrealdb/issues/1903
    final cos =
        db.query("RETURN vector::similarity::cosine([1,2,3],[4,5,6])", {});

    debugPrint("cos $cos");
    */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SurrealDB.wasm Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SurrealDB.wasm Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text),
          ],
        ),
      ),
    );
  }
}
