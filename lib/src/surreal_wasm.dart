import 'package:surrealdb_js/surrealdb_js.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

/// Simplify the instantiation of the [Surreal] class with the [WasmEngine].
class SurrealWasm {
  /// Returns a new instance of the [Surreal] class with the [WasmEngine].
  static Surreal getInstance() {
    return Surreal({'engines': WasmEngine()});
  }
}
