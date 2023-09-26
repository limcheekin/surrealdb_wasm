import 'package:js/js.dart';

@JS()
class SurrealWrapper {
  external Promise<void> connect(String endpoint, [String? opts]);
  external Promise<void> use(String value);
  external Promise<void> set(String key, String value);
  external Promise<void> unset(String key);
  external Promise<String> signup(String credentials);
  external Promise<String> signin(String credentials);
  external Promise<void> invalidate();
  external Promise<void> authenticate(String token);
  external Promise<String> query(String sql, String bindings);
  external Promise<String> select(String resource);
  external Promise<String> create(String resource, String data);
  external Promise<String> update(String resource, String data);
  external Promise<String> merge(String resource, String data);
  external Promise<String> patch(String resource, String data);
  external Promise<String> delete(String resource);
  external Promise<String> version();
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
