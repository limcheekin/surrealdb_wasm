# Contribution Guide

Welcome to the surrealdb_wasm project! We're excited to have you as a potential contributor. This guide will help you get started and make meaningful contributions to our project.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Licensing](#licensing)
3. [Code of Conduct](#code-of-conduct)
4. [Getting Started](#getting-started)
5. [Contributor Guidelines](#contributor-guidelines)
6. [Coding Standards](#coding-standards)
7. [Issue and Pull Request Management](#issue-and-pull-request-management)
8. [Testing and Quality Assurance](#testing-and-quality-assurance)
9. [Documentation](#documentation)
10. [Community Guidelines](#community-guidelines)
11. [Recognizing Contributions](#recognizing-contributions)
12. [Updating the Guide](#updating-the-guide)
13. [Feedback and Support](#feedback-and-support)

### Project Overview

The Flutter SurrealDB WebAssembly (WASM) package is a powerful integration for Flutter, built upon the foundation of [surrealdb.wasm](https://github.com/surrealdb/surrealdb.wasm), the WebAssembly engine for the SurrealDB JavaScript SDK. Consequently, the [surrealdb_js](https://pub.dev/packages/surrealdb_js) package will provide an unified API for the WebAssembly engine. We value contributions that enhance this project's functionality and maintain its quality.

### Licensing

This project is licensed under the [MIT License](LICENSE.md). By contributing, you agree to license your contributions under the same terms.

### Code of Conduct

Please review our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing. We prioritize a welcoming and inclusive community.

### Getting Started

1. Fork and clone the repository: https://github.com/limcheekin/surrealdb_wasm/fork
2. Install dependencies: `flutter pub get`
3. Set up your development environments:
   - [Download and install Node.js and NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) to build `surrealdb_wasm.js` with the `npm run package` command after making changes to [surrealdb.js](https://github.com/limcheekin/surrealdb_wasm/blob/main/assets/wasm/surrealdb/surrealdb.js) file.
   - [Install SurrealDB on Linux](https://surrealdb.com/docs/surrealdb/installation/linux).
   - Download [Chrome Driver](https://chromedriver.chromium.org/downloads) for integration test execution.

### Contributor Guidelines

We welcome various types of contributions, including code, documentation, and testing. To contribute:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Implement your changes.
4. Write tests where applicable.
5. Submit a pull request following the template provided.

### Coding Standards

The project utilizes the [very_good_analysis](https://pub.dev/packages/very_good_analysis) package. Before committing any changes to the repository, please ensure that, after running the `flutter analyze` command, you receive the message 'No issues found!'.

### Issue and Pull Request Management

- [Create an Issue](https://github.com/limcheekin/surrealdb_wasm/issues/new) for bug reports, feature requests, or discussions.
- When creating a pull request, ensure it is clear, addresses an existing issue, and follows the template.
- If you are new to using Pull Request, you can learn how with this _free_ series: [How to Contribute to an Open Source Project on GitHub](https://kcd.im/pull-request)

### Testing and Quality Assurance

We maintain a rigorous testing process. Please ensure thorough testing of your changes by following these steps:

1. To execute integration tests using the `flutter drive` command, start chromedriver with the following command before running any integration tests:

   ```bash
   ./chromedriver --port=4444
   ```

2. Run the integration tests in debug mode using the following command and resolve any failed tests:

   ```bash
   ./local-integration-test.sh
   ```

3. Execute the integration tests in release and headless mode using the following command:

   ```bash
   ./ci-integration-test.sh
   ```

Please verify that you see the message 'All tests passed.' on the console in both steps 2 and 3.

### Documentation

Thorough documentation is of paramount importance. We kindly request that you create comprehensive DartDoc documentation for the newly implemented features in [lib/src/surrealdb_wasm.dart](https://github.com/limcheekin/surrealdb_wasm/blob/main/lib/src/surrealdb_wasm.dart) by refer to the documentation present in [assets/wasm/surrealdb/index.js](https://github.com/limcheekin/surrealdb_wasm/blob/main/assets/wasm/surrealdb/index.js). This documentation will greatly assist both users and contributors in gaining a better understanding of the project.

### Community Guidelines

We encourage a positive and collaborative atmosphere. Please be respectful and constructive in your interactions.

### Recognizing Contributions

We acknowledge contributors in our README and release notes. Your contributions are highly valued!

### Updating the Guide

If you find errors or want to improve this guide, feel free to open a pull request.

### Feedback and Support

For questions, feedback, or support, please contact [limcheekin@vobject.com](mailto:limcheekin@vobject.com).
