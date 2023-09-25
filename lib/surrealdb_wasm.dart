import 'dart:convert';

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
          jsonEncode(opts),
        ),
      );
    }
  }

  Future<void> use({String? ns, String? db}) async {
    Map<String, String> value;
    if (ns != null && db != null) {
      value = {"ns": ns, "db": db};
    } else if (ns != null) {
      value = {"ns": ns};
    } else if (db != null) {
      value = {"db": db};
    } else {
      value = {};
    }
    await promiseToFuture(
      surreal.use(
        jsonEncode(value),
      ),
    );
  }

  Future<Map<String, dynamic>> create(
      String resource, Map<String, dynamic> data) async {
    final result = await promiseToFuture(
      surreal.create(
        resource,
        jsonEncode(data),
      ),
    );
    return jsonDecode(result);
  }
}
