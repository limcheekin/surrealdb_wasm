# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Each new version will be released following the new version of the [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm).

Changes to the project are tracked using build numbers behind the version number, denoted as increments such as +1, +2, and so on.

## [Unreleased]

## [0.7.0+4] - 2024-02-01

- Updated unofficial surrealdb.wasm released for surrealdb v1.1.1.

## [0.7.0+3] - 2023-12-12

- Added transaction support.
- Implemented `set()`, `unset()`, `signup()`, `signin()`, `patch()`, `version()` and `health()`.
- Migrated from `wasm-flate` to `fflate` package.

## [0.7.0+1] - 2023-10-22

- Initial release 🎉
