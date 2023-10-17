library surrealdb_wasm;

import 'dart:convert';
import 'dart:js';

import 'package:js/js_util.dart';
import 'package:surrealdb_wasm/js.dart';

class Surreal {
  final surreal = SurrealWrapper();

  Future<void> connect(String endpoint,
      {Map<String, dynamic> options = const {}}) async {
    await promiseToFuture(
      surreal.connect(
        endpoint,
        jsonEncode(options),
      ),
    );
  }

  Future<void> use({String? ns, String? db}) async {
    Map<String, String> value = {};

    if (ns == null && db == null) {
      throw Exception('Either "ns" or "db" must have value!');
    } else if (ns != null && db != null) {
      value = {'ns': ns, 'db': db};
    } else if (ns != null) {
      value = {'ns': ns};
    } else if (db != null) {
      value = {'db': db};
    }

    await promiseToFuture(
      surreal.use(
        jsonEncode(value),
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

  Future<Object?> query(String sql,
      {Map<String, dynamic> bindings = const {}}) async {
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
