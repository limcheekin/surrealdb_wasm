# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Each new version will be released following the new version of the [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm).

Changes to the project are tracked using build numbers behind the version number, denoted as increments such as +1, +2, and so on.

## [Unreleased]

## [0.9.0+7] - 2024-03-13

- Feat: Upgraded to surrealdb.wasm 0.9.0, the official release of wasm module of the surrealdb 1.3.0.
- Feat: API breaking changes:
  - `db.select()` and `db.query()` that return single result, no longer requiring casting to `List` and retrieval by `.first`.
- Fix: Catched the error `Encountered a non-object value in array` within the library, preventing it from being exposed to the user. Reported the bug at [surrealdb.wasm#56](https://github.com/surrealdb/surrealdb.wasm/issues/56).


## [0.8.0+5] - 2024-03-07

- Upgraded to the official surrealdb.wasm 0.8.0 released for surrealdb 1.2.0.
- API breaking changes: 
  - Previous: `db.use(ns: 'test', db: 'test');`
  - Current: `db.use(namespace: 'test', database: 'test');` 
  
## [0.7.0+4] - 2024-02-01

- Upgraded to unofficial surrealdb.wasm released for surrealdb 1.1.1.

## [0.7.0+3] - 2023-12-12

- Added transaction support.
- Implemented `set()`, `unset()`, `signup()`, `signin()`, `patch()`, `version()` and `health()`.
- Migrated from `wasm-flate` to `fflate` package.

## [0.7.0+1] - 2023-10-22

- Initial release 🎉
