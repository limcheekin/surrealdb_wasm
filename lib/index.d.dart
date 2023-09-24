import 'package:js/js.dart';

@JS()
class SurrealDB {
  external dynamic connect(String endpoint, String? opts);
  external void use(String value);
  external void set(String key, dynamic value);
  external void unset(String key);
  external dynamic signup(dynamic credentials);
  external dynamic signin(dynamic credentials);
  external void invalidate();
  external void authenticate(String token);
  external dynamic query(String sql, dynamic bindings);
  external dynamic select(String resource);
  external dynamic create(String resource, String data);
  external dynamic update(String resource, dynamic data);
  external dynamic merge(String resource, dynamic data);
  external dynamic patch(String resource, dynamic data);
  external dynamic delete(String resource);
  external dynamic version();
  external void health();
}
