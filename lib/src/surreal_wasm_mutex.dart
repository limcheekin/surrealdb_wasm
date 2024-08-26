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
  Future<void> let(String key, Object value, {bool mutex = false}) async {
    if (!mutex) {
      await super.let(key, value);
    } else {
      await _mutex.protect(() async {
        return super.let(key, value);
      });
    }
  }

  @override
  Future<void> unset(String key, {bool mutex = false}) async {
    if (!mutex) {
      await super.unset(key);
    } else {
      await _mutex.protect(() async {
        return super.unset(key);
      });
    }
  }

  @override
  Future<Object?> signup(
    Map<String, dynamic> credentials, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.signup(credentials);
    } else {
      return _mutex.protect(() async {
        return super.signup(credentials);
      });
    }
  }

  @override
  Future<Object?> signin(
    Map<String, dynamic> credentials, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.signin(credentials);
    } else {
      return _mutex.protect(() async {
        return super.signin(credentials);
      });
    }
  }

  @override
  Future<void> invalidate({bool mutex = false}) async {
    if (!mutex) {
      await super.invalidate();
    } else {
      await _mutex.protect(() async {
        return super.invalidate();
      });
    }
  }

  @override
  Future<void> authenticate(String token, {bool mutex = false}) async {
    if (!mutex) {
      await super.authenticate(token);
    } else {
      await _mutex.protect(() async {
        return super.authenticate(token);
      });
    }
  }

  @override
  Future<Object?> info({bool mutex = false}) async {
    if (!mutex) {
      return super.info();
    } else {
      return _mutex.protect(() async {
        return super.info();
      });
    }
  }

  @override
  Future<Object?> patch(
    String resource,
    List<Map<String, dynamic>> data, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.patch(resource, data);
    } else {
      return _mutex.protect(() async {
        return super.patch(resource, data);
      });
    }
  }

  @override
  Future<String> version({bool mutex = false}) async {
    if (!mutex) {
      return super.version();
    } else {
      return _mutex.protect(() async {
        return super.version();
      });
    }
  }

  @override
  Future<void> connect(
    String endpoint, {
    Map<String, dynamic> options = const {},
    bool mutex = false,
  }) async {
    if (!mutex) {
      await super.connect(endpoint, options: options);
    } else {
      await _mutex.protect(() async {
        return super.connect(endpoint, options: options);
      });
    }
  }

  @override
  Future<void> close({bool mutex = false}) async {
    if (!mutex) {
      await super.close();
    } else {
      await _mutex.protect(() async {
        return super.close();
      });
    }
  }

  @override
  Future<void> use({
    String? namespace,
    String? database,
    bool mutex = false,
  }) async {
    if (!mutex) {
      await super.use(namespace: namespace, database: database);
    } else {
      await _mutex.protect(() async {
        return super.use(namespace: namespace, database: database);
      });
    }
  }

  @override
  Future<Object?> create(
    String resource,
    Object data, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.create(resource, data);
    } else {
      return _mutex.protect(() async {
        return super.create(resource, data);
      });
    }
  }

  @override
  Future<Object?> update(
    String resource,
    Object data, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.update(resource, data);
    } else {
      return _mutex.protect(() async {
        return super.update(resource, data);
      });
    }
  }

  @override
  Future<Object?> merge(
    String resource,
    Object data, {
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.merge(resource, data);
    } else {
      return _mutex.protect(() async {
        return super.merge(resource, data);
      });
    }
  }

  @override
  Future<Object?> select(String resource, {bool mutex = false}) async {
    if (!mutex) {
      return super.select(resource);
    } else {
      return _mutex.protect(() async {
        return super.select(resource);
      });
    }
  }

  @override
  Future<Object?> query(
    String sql, {
    Map<String, dynamic> bindings = const {},
    bool mutex = false,
  }) async {
    if (!mutex) {
      return super.query(sql, bindings: bindings);
    } else {
      return _mutex.protect(() async {
        return super.query(sql, bindings: bindings);
      });
    }
  }

  @override
  Future<Object?> delete(String resource, {bool mutex = false}) async {
    if (!mutex) {
      return super.delete(resource);
    } else {
      return _mutex.protect(() async {
        return super.delete(resource);
      });
    }
  }
}
