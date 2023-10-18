// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Web Browser Tests'),
        ),
        body: const Center(
          child: Text('Running Browser Tests...'),
        ),
      ),
    );
  }
}
