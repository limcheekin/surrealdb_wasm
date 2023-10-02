import 'package:js/js.dart';

@JS()
class SurrealWrapper {
  external Promise<void> connect(String endpoint, [dynamic opts]);
  external Promise<void> use(dynamic value);
  external Promise<void> set(String key, dynamic value);
  external Promise<void> unset(String key);
  external Promise<dynamic> signup(dynamic credentials);
  external Promise<dynamic> signin(dynamic credentials);
  external Promise<void> invalidate();
  external Promise<void> authenticate(String token);
  external Promise<dynamic> query(String sql, [dynamic bindings]);
  external Promise<dynamic> select(String resource);
  external Promise<dynamic> create(String resource, dynamic data);
  external Promise<dynamic> update(String resource, dynamic data);
  external Promise<dynamic> merge(String resource, dynamic data);
  external Promise<dynamic> patch(String resource, dynamic data);
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
