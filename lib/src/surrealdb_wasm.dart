import 'dart:convert';

import 'package:js/js_util.dart';
import 'package:surrealdb_wasm/src/js.dart';

/// The Surreal class is for interacting with the SurrealDB WebAssembly library.
///
/// To use SurrealDB, you should first call [connect] to establish a connection
/// to the Surreal server, and then you can perform operations like [use],
/// [create], [update], [merge], [select], [query], [delete], etc.
class Surreal {
  final _surreal = SurrealWrapper();

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
  /// The optional [ns] parameter is the namespace,
  /// and the optional [db] parameter is the database.
  ///
  /// If neither [ns] nor [db] is provided, it will throw an exception.
  ///
  /// Example usage:
  /// ```dart
  /// // Switch to a namespace
  /// await db.use(ns: 'namespace');
  ///
  /// // Switch to a database
  /// await db.use(db: 'database');
  ///
  /// // Switch both
  /// await db.use(ns: 'namespace', db: 'database');
  /// ```
  Future<void> use({String? ns, String? db}) async {
    var value = <String, String>{};

    if (ns == null && db == null) {
      throw Exception('Either "ns" or "db" must have value!');
    } else if (ns != null && db != null) {
      value = {'ns': ns, 'db': db};
    } else if (ns != null) {
      value = {'ns': ns};
    } else if (db != null) {
      value = {'db': db};
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
    return dartify(result);
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
    return dartify(result);
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
    return dartify(result);
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
    final result = await promiseToFuture<Object?>(
      _surreal.select(
        resource,
      ),
    );
    return dartify(result);
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
  /// final people = await db.query('SELECT * FROM type::table($table)',
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
    return dartify(result);
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
    final result = await promiseToFuture<Object?>(
      _surreal.delete(
        resource,
      ),
    );
    return dartify(result);
  }
}
