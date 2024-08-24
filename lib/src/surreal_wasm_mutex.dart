import 'package:mutex/mutex.dart';
import 'package:surrealdb_js/surrealdb_js.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

/// The class implemented to workaround the following issue
/// of the surrealdb.wasm:
/// https://github.com/surrealdb/surrealdb.wasm/issues/87.
class SurrealWasmMutex extends Surreal {
  /// Instantiation of the [Surreal] class with the [WasmEngine].
  SurrealWasmMutex() : super({'engines': WasmEngine()});
  final _mutex = Mutex();

  /// Returns a new instance of the [Surreal] class
  /// with the [SurrealWasmMutex] implementation.
  static Surreal getInstance() {
    return SurrealWasmMutex();
  }

  @override
  Future<void> let(String key, Object value) async {
    await _mutex.protect(() async {
      return super.let(key, value);
    });
  }

  @override
  Future<void> unset(String key) async {
    await _mutex.protect(() async {
      return super.unset(key);
    });
  }

  @override
  Future<Object?> signup(Map<String, dynamic> credentials) async {
    return _mutex.protect(() async {
      return super.signup(credentials);
    });
  }

  @override
  Future<Object?> signin(Map<String, dynamic> credentials) async {
    return _mutex.protect(() async {
      return super.signin(credentials);
    });
  }

  @override
  Future<void> invalidate() async {
    await _mutex.protect(() async {
      return super.invalidate();
    });
  }

  @override
  Future<void> authenticate(String token) async {
    await _mutex.protect(() async {
      return super.authenticate(token);
    });
  }

  @override
  Future<Object?> info() async {
    return _mutex.protect(() async {
      return super.info();
    });
  }

  @override
  Future<Object?> patch(
    String resource,
    List<Map<String, dynamic>> data,
  ) async {
    return _mutex.protect(() async {
      return super.patch(resource, data);
    });
  }

  @override
  Future<String> version() async {
    return _mutex.protect(() async {
      return super.version();
    });
  }

  @override
  Future<void> connect(
    String endpoint, {
    Map<String, dynamic> options = const {},
  }) async {
    await _mutex.protect(() async {
      return super.connect(endpoint, options: options);
    });
  }

  @override
  Future<void> close() async {
    await _mutex.protect(() async {
      return super.close();
    });
  }

  @override
  Future<void> use({String? namespace, String? database}) async {
    await _mutex.protect(() async {
      return super.use(namespace: namespace, database: database);
    });
  }

  @override
  Future<Object?> create(String resource, Object data) async {
    return _mutex.protect(() async {
      return super.create(resource, data);
    });
  }

  @override
  Future<Object?> update(String resource, Object data) async {
    return _mutex.protect(() async {
      return super.update(resource, data);
    });
  }

  @override
  Future<Object?> merge(String resource, Object data) async {
    return _mutex.protect(() async {
      return super.merge(resource, data);
    });
  }

  @override
  Future<Object?> select(String resource) async {
    return _mutex.protect(() async {
      return super.select(resource);
    });
  }

  @override
  Future<Object?> query(
    String sql, {
    Map<String, dynamic> bindings = const {},
  }) async {
    return _mutex.protect(() async {
      return super.query(sql, bindings: bindings);
    });
  }

  @override
  Future<Object?> delete(String resource) async {
    return _mutex.protect(() async {
      return super.delete(resource);
    });
  }
}
