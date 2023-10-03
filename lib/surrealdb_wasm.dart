library surrealdb_wasm;

import 'dart:convert';
import 'dart:js';

import 'package:js/js_util.dart';
import 'package:surrealdb_wasm/js.dart';

class Surreal {
  final surreal = SurrealWrapper();

  Future<void> connect(String endpoint, [Map<String, dynamic>? opts]) async {
    if (opts == null) {
      await promiseToFuture(
        surreal.connect(
          endpoint,
        ),
      );
    } else {
      await promiseToFuture(
        surreal.connect(
          endpoint,
          JsObject.jsify(opts),
        ),
      );
    }
  }

  Future<void> use({String? ns, String? db}) async {
    final value = NamespaceDatabase(ns: ns, db: db);
    await promiseToFuture(
      surreal.use(
        value,
      ),
    );
  }

  Future<Object?> create(String resource, dynamic data) async {
    final result = await promiseToFuture(
      surreal.create(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return dartify(result);
  }

  Future<Object?> update(String resource, dynamic data) async {
    final result = await promiseToFuture(
      surreal.update(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return dartify(result);
  }

  Future<Object?> merge(String resource, dynamic data) async {
    final result = await promiseToFuture(
      surreal.merge(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return dartify(result);
  }

  Future<Object?> select(String resource) async {
    final result = await promiseToFuture(
      surreal.select(
        resource,
      ),
    );
    return dartify(result);
  }

  Future<Object?> query(String sql, [Map<String, dynamic>? bindings]) async {
    final result = await promiseToFuture(
      surreal.query(
        sql,
        jsonEncode(bindings),
      ),
    );
    return dartify(result);
  }

  Future<Object?> delete(String resource) async {
    final result = await promiseToFuture(
      surreal.delete(
        resource,
      ),
    );
    return dartify(result);
  }
}

class NamespaceDatabase {
  final String? ns;
  final String? db;

  NamespaceDatabase({this.ns, this.db});
}
