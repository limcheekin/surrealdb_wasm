//import 'authentication_test.dart' as authentication;
//import 'info_for_ns_test.dart' as info_for_ns;
import 'patch_test.dart' as patch;
import 'surrealdb_wasm_test.dart' as surrealdb_wasm;
import 'transaction_test.dart' as transaction;

void main() {
  //authentication.main();
  //info_for_ns.main();
  patch.main();
  patch.main(wasm: true);
  surrealdb_wasm.main();
  surrealdb_wasm.main(wasm: true);
  transaction.main();
  transaction.main(wasm: true);
}
