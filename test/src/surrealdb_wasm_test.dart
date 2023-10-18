// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

void main() {
  group('SurrealdbWasm', () {
    test('can be instantiated', () {
      expect(Surreal(), isNotNull);
    });
  });
}
