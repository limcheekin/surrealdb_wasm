// ignore_for_file: public_member_api_docs

import 'package:js/js.dart';

/// The SurrealWrapper class is for js-interop to it's JavaScript implementation
/// at the assets/wasm/surrealdb/surrealdb.js.
@JS('SurrealWrapper')
class SurrealWrapper {
  external factory SurrealWrapper();
  external Promise<void> connect(String endpoint, dynamic opts);
  external Promise<void> use(dynamic value);
  external Promise<void> set(String key, dynamic value);
  external Promise<void> unset(String key);
  external Promise<dynamic> signup(dynamic credentials);
  external Promise<dynamic> signin(dynamic credentials);
  external Promise<void> invalidate();
  external Promise<void> authenticate(String token);
  external Promise<dynamic> query(String sql, dynamic bindings);
  external Promise<dynamic> select(String resource);
  external Promise<dynamic> create(String resource, dynamic data);
  external Promise<dynamic> update(String resource, dynamic data);
  external Promise<dynamic> merge(String resource, dynamic data);
  external Promise<dynamic> patch(String resource, dynamic data);
  external Promise<dynamic> delete(String resource);
  external Promise<dynamic> version();
  external Promise<void> health();
}

/// Dart bindings to JavaScript Promise class.
@JS()
@anonymous
class Promise<T> {
  external factory Promise();
  external Promise<dynamic> then<TResult1, TResult2>(
    dynamic Function(T value)? onfulfilled,
    dynamic Function(dynamic reason)? onrejected,
  );
}
