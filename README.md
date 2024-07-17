# surrealdb_wasm

[![pub package](https://img.shields.io/pub/v/surrealdb_wasm.svg?label=surrealdb_wasm&color=blue)](https://pub.dartlang.org/packages/surrealdb_wasm)
[![browser tests](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml/badge.svg)](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

The Flutter SurrealDB WebAssembly (WASM) package is a powerful integration for Flutter, built upon the foundation of [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm), the WebAssembly engine for the SurrealDB JavaScript SDK. Consequently, the [surrealdb_js](https://pub.dev/packages/surrealdb_js) package will provide an unified API for the WebAssembly engine.

## 🔍 Demo

Try out surreal_wasm applications in your browser:

- [Example App](https://limcheekin.github.io/surrealdb_wasm/)
- [SurrealDB Console](https://www.fluwix.com/surrealdb_console)

## 💻 Installation

**❗ In order to start using surrealdb_wasm you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
flutter pub add surrealdb_wasm
```

Alternatively, add `surrealdb_wasm` to your `pubspec.yaml`:

```yaml
dependencies:
  surrealdb_wasm:
```

Install it:

```sh
flutter pub get
```

Lastly, add the following code before the `</head>` tag in the `web/index.html` file:
```html
<script type="module">
  import { Surreal, StringRecordId } from "/assets/packages/surrealdb_js/assets/js/index.bundled.mjs";
  import { surrealdbWasmEngines } from "/assets/packages/surrealdb_wasm/assets/wasm/surrealdb/esm.bundled.js";
  
  // expose the type to the global scope
  globalThis.SurrealJS = Surreal;
  globalThis.StringRecordId = StringRecordId;
  globalThis.WasmEngine = surrealdbWasmEngines;
</script>
```

## ✨ Features

Please refer to the [surrealdb_js](https://pub.dev/packages/surrealdb_js#-features) package for a comprehensive list of features.

## 🏃 Examples

### Basic

```dart
import 'package:surrealdb_js/surrealdb_js.dart';
import 'package:surrealdb_wasm/surrealdb_wasm.dart';

final db = Surreal({'engines': WasmEngine()});

await db.connect('indxdb://surreal');
await db.use(namespace: 'test', database: 'test');

final created = db.create('person',
          {
            'title': 'CTO',
            'name': {
              'first': 'Tom',
              'last': 'Jerry',
            },
            'marketing': true,
          },
        );

final id = created['id'].toString();
final merged = await db.merge(
        id,
        {
          'marketing': false,
        },
      );

final tom = await db.select(id);

final deleted = await db.delete(id);
```

For more code examples, kindly refer to the [integration test](https://github.com/limcheekin/surrealdb_wasm/blob/main/integration_test/surrealdb_wasm_test.dart) and the [example project](https://github.com/limcheekin/surrealdb_wasm/blob/main/example/lib/main.dart).

### Transaction Support

```dart
final result = await db.transaction((txn) async {
    txn.query('DEFINE TABLE test SCHEMAFULL;');
    txn.query('DEFINE FIELD id ON test TYPE record;');
    txn.query('DEFINE FIELD name ON test TYPE string;');
    txn.query(
      r'CREATE test SET name = $name;',
      bindings: {'name': 'John'},
    );
    if (somethingWrong) {
      txn.cancel();
    }
});
```

For more code examples, kindly refer to the [integration test of transaction](https://github.com/limcheekin/surrealdb_wasm/blob/main/integration_test/transaction_test.dart).

## 🧑‍💼 Contributing

Contributions are welcome! Please check out the unimplemented features or issues on the repository, and feel free to open a pull request.
For more information, please see the [contribution guide](CONTRIBUTING.md).

<a href="https://github.com/limcheekin/surrealdb_wasm/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=limcheekin/surrealdb_wasm" />
</a>

## 📔 License

This project is licensed under the terms of the MIT license.

## 🗒️ Citation

If you utilize this package, please consider citing it with:

```
@misc{surrealdb_wasm,
  author = {Lim Chee Kin},
  title = {surrealdb_wasm: Flutter SurrealDB WebAssembly(WASM) package},
  year = {2023},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/limcheekin/surrealdb_wasm}},
}
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
