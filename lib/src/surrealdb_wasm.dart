import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:js/js_util.dart';
import 'package:surrealdb_wasm/src/js.dart';

/// The Surreal class is for interacting with the SurrealDB WebAssembly library.
///
/// To use SurrealDB, you should first call [connect] to establish a connection
/// to the Surreal server, and then you can perform operations like [use],
/// [create], [update], [merge], [select], [query], [delete], etc.
class Surreal {
  final _surreal = SurrealWrapper();

  /// Assigns a value as a parameter for this connection.
  ///
  /// The [key] is the parameter name, and [value] is the value to be assigned.
  Future<void> set(String key, dynamic value) async {
    await promiseToFuture<void>(
      _surreal.set(key, jsonEncode(value)),
    );
  }

  /// Removes a parameter from this connection.
  ///
  /// The [key] is the parameter name to be removed.
  Future<void> unset(String key) async {
    await promiseToFuture<void>(
      _surreal.unset(key),
    );
  }

  /// Signs up a user to a specific authentication scope.
  ///
  /// The [credentials] is a map containing the user's sign-up information.
  Future<Object?> signup(Map<String, dynamic> credentials) async {
    final result = await promiseToFuture<Object?>(
      _surreal.signup(jsonEncode(credentials)),
    );
    return dartify(result);
  }

  /// Signs in a user to a specific authentication scope.
  ///
  /// The [credentials] is a map containing the user's sign-in information.
  Future<Object?> signin(Map<String, dynamic> credentials) async {
    final result = await promiseToFuture<String>(
      _surreal.signin(jsonEncode(credentials)),
    );
    return dartify(result)!;
  }

  /// Invalidates the authentication for the current connection.
  Future<void> invalidate() async {
    await promiseToFuture<void>(
      _surreal.invalidate(),
    );
  }

  /// Authenticates the current connection with a JWT token.
  ///
  /// The [token] is the JWT token used for authentication.
  Future<void> authenticate(String token) async {
    await promiseToFuture<void>(
      _surreal.authenticate(token),
    );
  }

  /// Applies JSON Patch changes to a resource.
  ///
  /// The [resource] is the name of the resource to patch,
  /// and [data] is the JSON Patch data.
  Future<Object?> patch(
    String resource,
    List<Map<String, dynamic>> data,
  ) async {
    final result = await promiseToFuture<Object?>(
      _surreal.patch(resource, jsonEncode(data)),
    );
    return dartify(result);
  }

  /// Returns the version of the server.
  Future<String> version() async {
    final result = await promiseToFuture<String>(
      _surreal.version(),
    );
    return result;
  }

  /// Checks whether the server is healthy.
  Future<void> health() async {
    await promiseToFuture<void>(
      _surreal.health(),
    );
  }

  /// Connect to a database engine.
  ///
  /// The [endpoint] is the URL of the Surreal server to connect to.
  /// The optional [options] parameter allows you to specify connection options
  /// as a Map.
  ///
  /// Example usage:
  /// ```dart
  /// final db = new Surreal();
  ///
  /// // Connect to a WebSocket engine
  /// await db.connect('ws://localhost:8000');
  ///
  /// // Connect to an HTTP engine
  /// await db.connect('http://localhost:8000');
  ///
  /// // Connect to a memory engine
  /// await db.connect('mem://');
  ///
  /// // Connect to an IndxDB engine
  /// await db.connect('indxdb://MyDatabase');
  ///
  /// // Limit number of concurrent connections
  /// await db.connect('indxdb://MyDatabase', options: { capacity: 100000 });
  ///
  /// // Enable strict mode on a local engine
  /// await db.connect('indxdb://MyDatabase', options: { strict: true });
  ///
  /// // Enable notifications
  /// await db.connect('indxdb://MyDatabase', options: { notifications: true });
  ///
  /// // Set query timeout time in seconds
  /// await db.connect('indxdb://MyDatabase', options: { query_timeout: 60 });
  ///
  /// // Set transaction timeout time in seconds
  /// await db.connect('indxdb://MyDatabase', options: { transaction_timeout: 60 });
  ///
  /// // Set changefeeds tick interval in seconds
  /// await db.connect('indxdb://MyDatabase', options: { tick_interval: 60 });
  ///
  /// // Configure a system user
  /// await db.connect('indxdb://MyDatabase', options: { user: { username: "root", password: "root" } });
  ///
  /// // Enable all capabilities
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: true });
  ///
  /// // Disable all capabilities
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: false });
  ///
  /// // Allow guest access
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { guest_access: true } });
  ///
  /// // Allow all SurrealQL functions
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { functions: true } });
  ///
  /// // Disallow all SurrealQL functions
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { functions: false } });
  ///
  /// // Allow only certain SurrealQL functions
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { functions: ["fn", "string", "array::join"] } });
  ///
  /// // Allow and disallow certain SurrealQL functions
  /// await db.connect('indxdb://MyDatabase', options: {
  ///     capabilities: {
  ///         functions: {
  ///             allow: ["fn", "string", "array::join"], // You can also use `true` or `false` here to allow all or allow none
  ///             deny: ["array"],                        // You can also use `true` or `false` here to deny all or deny none
  ///         },
  ///     },
  /// });
  ///
  /// // Allow all network targets
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { network_targets: true } });
  ///
  /// // Disallow all network targets
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { network_targets: false } });
  ///
  /// // Allow only certain network targets
  /// await db.connect('indxdb://MyDatabase', options: { capabilities: { network_targets: ["http"] } });
  ///
  /// // Allow and disallow certain network targets
  /// await db.connect('indxdb://MyDatabase', options: {
  ///     capabilities: {
  ///         network_targets: {
  ///             allow: ["http"],                      // You can also use `true` or `false` here to allow all or allow none
  ///             deny: ["ssh"],                        // You can also use `true` or `false` here to deny all or deny none
  ///         },
  ///     },
  /// });
  /// ```
  Future<void> connect(
    String endpoint, {
    Map<String, dynamic> options = const {},
  }) async {
    await promiseToFuture<void>(
      _surreal.connect(
        endpoint,
        jsonEncode(options),
      ),
    );
  }

  /// Switch to a specific namespace or database.
  ///
  /// The optional [namespace] parameter,
  /// and the optional [database] parameter.
  ///
  /// If neither [namespace] nor [database] is provided,
  /// it will throw an exception.
  ///
  /// Example usage:
  /// ```dart
  /// // Switch to a namespace
  /// await db.use(namespace: 'namespace');
  ///
  /// // Switch to a database
  /// await db.use(database: 'database');
  ///
  /// // Switch both
  /// await db.use(namespace: 'namespace', database: 'database');
  /// ```
  Future<void> use({String? namespace, String? database}) async {
    var value = <String, String>{};

    if (namespace == null && database == null) {
      throw Exception('Either "namespace" or "database" must have value!');
    } else if (namespace != null && database != null) {
      value = {'namespace': namespace, 'database': database};
    } else if (namespace != null) {
      value = {'namespace': namespace};
    } else if (database != null) {
      value = {'database': database};
    }

    await promiseToFuture<void>(
      _surreal.use(
        jsonEncode(value),
      ),
    );
  }

  /// Creates a new resource(record) with the given data.
  ///
  /// The [resource] is the name of the resource to create,
  /// and [data] is the data to be stored.
  ///
  /// Example usage:
  /// ```dart
  /// // Create a record with no fields set
  /// final person = await db.create('person');
  ///
  /// Create a record with fields set
  /// final person = await db.create('person', {
  ///     name: 'Tobie',
  ///     settings: {
  ///         active: true,
  ///         marketing: true
  ///     }
  /// });
  /// ```
  Future<Object?> create(String resource, dynamic data) async {
    final result = await promiseToFuture<Object?>(
      _surreal.create(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return _wrap(result);
  }

  /// Updates a specific resource(record)
  /// or all resources(records) with the given data.
  ///
  /// The [resource] is the name of the resource to update,
  /// and [data] is the new data to replace the existing data.
  ///
  /// Example usage:
  /// ```dart
  /// // Replace all records in a table with the specified data.
  /// final people = await db.update('person', {
  ///     name: 'Tobie',
  ///     settings: {
  ///         active: true,
  ///         marketing: true
  ///     }
  /// });
  ///
  /// // Replace a range of records with the specified data.
  /// final person = await db.update('person:jane..john', {
  ///     name: 'Tobie',
  ///     settings: {
  ///         active: true,
  ///         marketing: true
  ///     }
  /// });
  ///
  /// // Replace the current document / record data with the specified data.
  /// final person = await db.update('person:tobie', {
  ///     name: 'Tobie',
  ///     settings: {
  ///         active: true,
  ///         marketing: true
  ///     }
  /// });
  /// ```
  Future<Object?> update(String resource, dynamic data) async {
    final result = await promiseToFuture<Object?>(
      _surreal.update(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return _wrap(result);
  }

  /// Merges data into an existing resource(record) or resources(records).
  ///
  /// The [resource] is the name of the resource to update,
  /// and [data] is the data to merge.
  ///
  /// Example usage:
  /// ```dart
  /// // Merge all records in a table with specified data.
  /// final person = await db.merge('person', {
  ///     marketing: true
  /// });
  ///
  /// // Merge a range of records with the specified data.
  /// final person = await db.merge('person:jane..john', {
  ///     marketing: true
  /// });
  ///
  /// // Merge the current document / record data with the specified data.
  /// final person = await db.merge('person:tobie', {
  ///     marketing: true
  /// });
  /// ```
  Future<Object?> merge(String resource, dynamic data) async {
    final result = await promiseToFuture<Object?>(
      _surreal.merge(
        resource,
        data is Map || data is Iterable ? jsonEncode(data) : data,
      ),
    );
    return _wrap(result);
  }

  /// Selects and retrieves all resources(records)
  /// or a specific resource(record).
  ///
  /// The [resource] is the name of the resource to select.
  ///
  /// Example usage:
  /// ```dart
  /// // Select all records from a table
  /// final people = await db.select('person');
  ///
  /// // Select a range records from a table
  /// final people = await db.select('person:jane..john');
  ///
  /// // Select a specific record from a table
  /// final person = await db.select('person:h5wxrf2ewk8xjxosxtyc');
  /// ```
  Future<Object?> select(String resource) async {
    return _handleError(
      resource,
      (resource) async {
        final result = await promiseToFuture<Object?>(
          _surreal.select(
            resource,
          ),
        );
        return _wrap(result);
      },
    );
  }

  /// Executes a SurrealQL query on the database.
  ///
  /// The [sql] parameter is the SurrealQL query string,
  /// and the optional [bindings] parameter allows you
  /// to pass parameters as a Map.
  ///
  /// Example usage:
  /// ```dart
  /// // Run a query without bindings
  /// final people = await db.query('SELECT * FROM person');
  ///
  /// // Run a query with bindings
  /// final people = await db.query(r'SELECT * FROM type::table($table)',
  ///                               bindings: { table: 'person' });
  /// ```
  Future<Object?> query(
    String sql, {
    Map<String, dynamic> bindings = const {},
  }) async {
    final result = await promiseToFuture<Object?>(
      _surreal.query(
        sql,
        jsonEncode(bindings),
      ),
    );
    return _wrap(result);
  }

  /// Deletes a specific resource(record) or all resources(records).
  ///
  /// The [resource] is the name of the resource to delete.
  ///
  /// Example usage:
  /// ```dart
  /// // Delete all records from a table
  /// final records = await db.delete('person');
  ///
  /// // Delete a range records from a table
  /// final people = await db.delete('person:jane..john');
  ///
  /// // Delete a specific record from a table
  /// final record = await db.delete('person:h5wxrf2ewk8xjxosxtyc');
  /// ```
  Future<Object?> delete(String resource) async {
    return _handleError(
      resource,
      (resource) async {
        final result = await promiseToFuture<Object?>(
          _surreal.delete(
            resource,
          ),
        );
        return _wrap(result);
      },
    );
  }

  Future<Object?> _handleError(
    String resource,
    Future<Object?> Function(
      String resource,
    ) sqlFunction,
  ) async {
    try {
      return await sqlFunction(resource);
    } catch (e) {
      // Catch the error.
      if (e is String &&
          e.contains('Encountered a non-object value in array')) {
        // If it's the specific error we're looking for,
        // not handled due to the reported issue.
        // ignore: avoid_print
        print('''
ERROR: "$e" is not handled.
Please see https://github.com/surrealdb/surrealdb.wasm/issues/56.''');
        return null;
      } else {
        // If it's any other error, rethrow it.
        rethrow;
      }
    }
  }

  Object? _wrap(Object? result) {
    if (result == null || dartify(result) == null) return null;
    final list = dartify(result)! as List;
    return list.isEmpty ? null : (list.length == 1 ? list.first : list);
  }

  /// Executes a transaction by calling the provided [action] function
  /// with a [Transaction] object, allowing the execution of various database
  /// operations within the transaction.
  ///
  /// Optionally, a [timeout] duration can be specified to limit the execution
  /// time of the transaction. If the transaction takes longer than the
  /// specified duration, a timeout exception is throw.
  ///
  /// Example usage:
  /// ```dart
  /// await db.transaction(
  ///   (Transaction txn) async {
  ///     // Perform database operations using txn
  ///     txn.query('CREATE account:one SET balance = 135605.16;');
  ///     txn.query(r'UPDATE account:one SET balance += $amount',
  ///                    bindings: { amount: 300.00 });
  ///   },
  ///   timeout: const Duration(seconds: 60), // Custom timeout of 60 seconds
  /// );
  /// ```
  ///
  /// If the transaction is successfully executed within the specified timeout,
  /// the method returns the result of the transaction.
  ///
  /// Throws a [TimeoutException] if the transaction exceeds the specified
  /// [timeout].
  /// Throws an exception if any error occurs during the transaction execution.
  ///
  /// ```
  Future<Object?> transaction(
    Future<void> Function(Transaction txn) action, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // Create a new transaction object
    final txn = Transaction(this);

    // Call the action function with the transaction object
    await action(txn).timeout(timeout);

    // Execute the transaction
    return txn._execute();
  }
}

/// A class representing a database transaction
class Transaction {
  /// Creates a new [Transaction] instance with unique id.
  Transaction(this._db) {
    id = _generateId();
  }

  /// The statement to begin a database transaction.
  static const _beginTransaction = 'BEGIN TRANSACTION;';

  /// The statement to commit a database transaction.
  static const _commitTransaction = 'COMMIT TRANSACTION;';

  /// Indicates whether the transaction has been canceled by the user.
  @visibleForTesting
  bool isCancel = false;

  /// A buffer to store the SQL statements for the transaction.
  @visibleForTesting
  final buffer = StringBuffer(_beginTransaction);

  /// A random number generator for generating transaction Id.
  static final _random = Random();

  /// The Surreal instance associated with this transaction.
  final Surreal _db;

  /// The unique identifier for this transaction.
  late String id;

  /// Generates a unique identifier for the transaction based on
  /// the current timestamp and a random number.
  String _generateId() {
    // Get the current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate a random number
    final random = _random.nextInt(999999).toString().padLeft(6, '0');

    // Combine timestamp and random number to create a unique ID
    final id = '$timestamp$random';

    return id;
  }

  /// Cancels the transaction, preventing it from being executed.
  void cancel() {
    isCancel = true;
  }

  /// Executes the transaction and returns the result.
  ///
  /// If the transaction is canceled,
  /// a message indicating cancellation is returned.
  Future<Object?> _execute() async {
    if (!isCancel) {
      buffer.write(_commitTransaction);
      return _db.query(buffer.toString());
    } else {
      return 'Transaction has been canceled by user.';
    }
  }

  /// Executes SurrealQL statements on the database in a transaction.
  ///
  /// The [sql] parameter is the SurrealQL query string,
  /// and the optional [bindings] parameter allows you
  /// to pass parameters as a Map.
  ///
  /// Example usage:
  /// ```dart
  /// // Run a query without bindings
  /// db.query('CREATE account:one SET balance = 135605.16');
  ///
  /// // Run a query with bindings
  /// db.query(r'UPDATE account:one SET balance += $amount',
  ///                    bindings: { amount: 300.00 });
  /// ```
  void query(
    String sql, {
    Map<String, dynamic> bindings = const {},
  }) {
    if (bindings.isNotEmpty) {
      final regex = RegExp(r'\$(\w+)');
      final matches = regex.allMatches(sql);
      final params = <String, String>{};
      for (final match in matches) {
        final key = match.group(1)!;
        params[key] = bindings[key] is Map || bindings[key] is Iterable
            ? jsonEncode(bindings[key])
            : bindings[key] is String
                ? '"${bindings[key]}"'
                : bindings[key].toString();
      }
      final parameterizedSql = sql.replaceAllMapped(
        regex,
        (match) => params[match.group(1)]!,
      );
      buffer.write(parameterizedSql);
    } else {
      buffer.write(sql);
    }
  }
}
