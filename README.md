# surrealdb_wasm

[![pub package](https://img.shields.io/pub/v/surrealdb_wasm.svg?label=surrealdb_wasm&color=blue)](https://pub.dartlang.org/packages/surrealdb_wasm)
[![browser tests](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml/badge.svg)](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

The Flutter SurrealDB WebAssembly (WASM) package is a powerful integration for Flutter, built upon the foundation of [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm), the official SurrealDB library for WebAssembly.

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

## ✨ Features

- <input type="checkbox" checked disabled /> [x] `connect()`
- <input type="checkbox" checked disabled /> [x] `use()`
- <input type="checkbox" checked disabled /> [x] `create()`
- <input type="checkbox" checked disabled /> [x] `update()`
- <input type="checkbox" checked disabled /> [x] `merge()`
- <input type="checkbox" checked disabled /> [x] `delete()`
- <input type="checkbox" checked disabled /> [x] `select()`
- <input type="checkbox" checked disabled /> [x] `query()`
- <input type="checkbox" checked disabled /> [x] `transaction()`
- <input type="checkbox" checked disabled /> [x] `set()`
- <input type="checkbox" checked disabled /> [x] `unset()`
- <input type="checkbox" checked disabled /> [x] `signup()`
- <input type="checkbox" checked disabled /> [x] `signin()`
- <input type="checkbox" disabled /> [ ] `invalidate()`
- <input type="checkbox" disabled /> [ ] `authenticate()`
- <input type="checkbox" checked disabled /> [x] `patch()`
- <input type="checkbox" checked disabled /> [x] `version()`
- <input type="checkbox" checked disabled /> [x] `health()`

## 🏃 Examples

### Basic

```dart
final db = Surreal();

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

// created['id']: person:b9eht8bie8abf0vbcfxh
final merged = await db.merge(
        created['id'],
        {
          'marketing': false,
        },
      );

final tom = await db.select(created['id']);

final deleted = await db.delete(created['id']);
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

Contributions are welcome! Please check out the unimplemented features above, issues on the repository, and feel free to open a pull request.
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
