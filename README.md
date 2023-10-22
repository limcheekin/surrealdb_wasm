# surrealdb_wasm

[![pub package](https://img.shields.io/pub/v/surrealdb_wasm.svg?label=surrealdb_wasm&color=blue)](https://pub.dartlang.org/packages/surrealdb_wasm)
[![browser tests](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml/badge.svg)](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/browser-tests.yaml)
[![ci](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/limcheekin/surrealdb_wasm/actions/workflows/main.yaml)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

The Flutter SurrealDB WebAssembly (WASM) package is a powerful integration for Flutter, built upon the foundation of [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm), the official SurrealDB library for WebAssembly.

## 🔍 Demo

Try out surreal_wasm/example in your browser:
https://limcheekin.github.io/surrealdb_wasm/

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

- [x] `connect()`
- [x] `use()`
- [x] `create()`
- [x] `update()`
- [x] `merge()`
- [x] `delete()`
- [x] `select()`
- [x] `query()`
- [ ] `set()`
- [ ] `unset()`
- [ ] `signup()`
- [ ] `signin()`
- [ ] `invalidate()`
- [ ] `authenticate()`
- [ ] `patch()`
- [ ] `version()`
- [ ] `health()`

## 🏃 Examples

```dart
final db = Surreal();

await db.connect('indxdb://surreal');
await db.use(ns: 'test', db: 'test');

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

## 🧑‍💼 Contributing

Contributions are welcome! Please check out the unimplemented features above, issues on the repository, and feel free to open a pull request.
For more information, please see the [contribution guide](CONTRIBUTING.md).

<a href="https://github.com/limcheekin/surrealdb_wasm/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=limcheekin/surrealdb_wasm" />
</a>

## 📔 License

This project is licensed under the terms of the MIT license.

## 🗒️ Citation

If you utilize this repository, please consider citing it with:

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
