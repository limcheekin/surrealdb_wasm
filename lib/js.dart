import 'package:js/js.dart';

@JS()
class SurrealWrapper {
  external Promise<void> connect(String endpoint, [String? opts]);
  external Promise<void> use(String value);
  external Promise<void> set(String key, String value);
  external Promise<void> unset(String key);
  external Promise<dynamic> signup(String credentials);
  external Promise<dynamic> signin(String credentials);
  external Promise<void> invalidate();
  external Promise<void> authenticate(String token);
  external Promise<dynamic> query(String sql, String bindings);
  external Promise<dynamic> select(String resource);
  external Promise<dynamic> create(String resource, String data);
  external Promise<dynamic> update(String resource, String data);
  external Promise<dynamic> merge(String resource, String data);
  external Promise<dynamic> patch(String resource, String data);
  external Promise<dynamic> delete(String resource);
  external Promise<dynamic> version();
  external Promise<void> health();
}

// import "lib.es5.d.dart";
@JS()
@anonymous
class Promise<T> {
  external Promise<dynamic> then<TResult1, TResult2>(
      dynamic Function(T value)? onfulfilled,
      dynamic Function(dynamic reason)? onrejected);
  external factory Promise();
}
