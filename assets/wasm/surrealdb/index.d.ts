/* tslint:disable */
/* eslint-disable */
/**
*/
export function setup(): void;
/**
*/
export class IntoUnderlyingByteSource {
  free(): void;
/**
* @param {any} controller
*/
  start(controller: any): void;
/**
* @param {any} controller
* @returns {Promise<any>}
*/
  pull(controller: any): Promise<any>;
/**
*/
  cancel(): void;
/**
*/
  readonly autoAllocateChunkSize: number;
/**
*/
  readonly type: string;
}
/**
*/
export class IntoUnderlyingSink {
  free(): void;
/**
* @param {any} chunk
* @returns {Promise<any>}
*/
  write(chunk: any): Promise<any>;
/**
* @returns {Promise<any>}
*/
  close(): Promise<any>;
/**
* @param {any} reason
* @returns {Promise<any>}
*/
  abort(reason: any): Promise<any>;
}
/**
*/
export class IntoUnderlyingSource {
  free(): void;
/**
* @param {any} controller
* @returns {Promise<any>}
*/
  pull(controller: any): Promise<any>;
/**
*/
  cancel(): void;
}
/**
* Raw options for [`pipeTo()`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream/pipeTo).
*/
export class PipeOptions {
  free(): void;
/**
*/
  readonly preventAbort: boolean;
/**
*/
  readonly preventCancel: boolean;
/**
*/
  readonly preventClose: boolean;
/**
*/
  readonly signal: AbortSignal | undefined;
}
/**
*/
export class QueuingStrategy {
  free(): void;
/**
*/
  readonly highWaterMark: number;
}
/**
* Raw options for [`getReader()`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream/getReader).
*/
export class ReadableStreamGetReaderOptions {
  free(): void;
/**
*/
  readonly mode: any;
}
/**
*/
export class Surreal {
  free(): void;
/**
* Construct the database engine
*
* ```js
* const db = new Surreal();
* ```
*/
  constructor();
/**
* Connect to a database engine
*
* ```js
* const db = new Surreal();
*
* // Connect to a WebSocket engine
* await db.connect('ws://localhost:8000');
*
* // Connect to an HTTP engine
* await db.connect('http://localhost:8000');
*
* // Connect to a memory engine
* await db.connect('mem://');
*
* // Connect to an IndxDB engine
* await db.connect('indxdb://MyDatabase');
*
* // Limit number of concurrent connections
* await db.connect('indxdb://MyDatabase', { capacity: 100000 });
*
* // Enable strict mode on a local engine
* await db.connect('indxdb://MyDatabase', { strict: true });
*
* // Enable notifications
* await db.connect('indxdb://MyDatabase', { notifications: true });
*
* // Set query timeout time in seconds
* await db.connect('indxdb://MyDatabase', { query_timeout: 60 });
*
* // Set transaction timeout time in seconds
* await db.connect('indxdb://MyDatabase', { transaction_timeout: 60 });
*
* // Set changefeeds tick interval in seconds
* await db.connect('indxdb://MyDatabase', { tick_interval: 60 });
*
* // Configure a system user
* await db.connect('indxdb://MyDatabase', { user: { username: "root", password: "root" } });
*
* // Enable all capabilities
* await db.connect('indxdb://MyDatabase', { capabilities: true });
*
* // Disable all capabilities
* await db.connect('indxdb://MyDatabase', { capabilities: false });
*
* // Allow guest access
* await db.connect('indxdb://MyDatabase', { capabilities: { guest_access: true } });
*
* // Allow all SurrealQL functions
* await db.connect('indxdb://MyDatabase', { capabilities: { functions: true } });
*
* // Disallow all SurrealQL functions
* await db.connect('indxdb://MyDatabase', { capabilities: { functions: false } });
*
* // Allow only certain SurrealQL functions
* await db.connect('indxdb://MyDatabase', { capabilities: { functions: ["fn", "string", "array::join"] } });
*
* // Allow and disallow certain SurrealQL functions
* await db.connect('indxdb://MyDatabase', {
*     capabilities: {
*         functions: {
*             allow: ["fn", "string", "array::join"], // You can also use `true` or `false` here to allow all or allow none
*             deny: ["array"],                        // You can also use `true` or `false` here to deny all or deny none
*         },
*     },
* });
*
* // Allow all network targets
* await db.connect('indxdb://MyDatabase', { capabilities: { network_targets: true } });
*
* // Disallow all network targets
* await db.connect('indxdb://MyDatabase', { capabilities: { network_targets: false } });
*
* // Allow only certain network targets
* await db.connect('indxdb://MyDatabase', { capabilities: { network_targets: ["http"] } });
*
* // Allow and disallow certain network targets
* await db.connect('indxdb://MyDatabase', {
*     capabilities: {
*         network_targets: {
*             allow: ["http"],                      // You can also use `true` or `false` here to allow all or allow none
*             deny: ["ssh"],                        // You can also use `true` or `false` here to deny all or deny none
*         },
*     },
* });
* ```
* @param {string} endpoint
* @param {any} opts
* @returns {Promise<void>}
*/
  connect(endpoint: string, opts: any): Promise<void>;
/**
* Switch to a specific namespace or database
*
* ```js
* const db = new Surreal();
*
* // Switch to a namespace
* await db.use({ ns: 'namespace' });
*
* // Switch to a database
* await db.use({ db: 'database' });
*
* // Switch both
* await db.use({ ns: 'namespace', db: 'database' });
* ```
* @param {any} value
* @returns {Promise<void>}
*/
  use(value: any): Promise<void>;
/**
* Assign a value as a parameter for this connection
*
* ```js
* await db.set('name', { first: 'Tobie', last: 'Morgan Hitchcock' });
* ```
* @param {string} key
* @param {any} value
* @returns {Promise<void>}
*/
  set(key: string, value: any): Promise<void>;
/**
* Remove a parameter from this connection
*
* ```js
* await db.unset('name');
* ```
* @param {string} key
* @returns {Promise<void>}
*/
  unset(key: string): Promise<void>;
/**
* Sign up a user to a specific authentication scope
*
* ```js
* const token = await db.signup({
*     namespace: 'namespace',
*     database: 'database',
*     scope: 'user_scope',
*     email: 'john.doe@example.com',
*     password: 'password123'
* });
* ```
* @param {any} credentials
* @returns {Promise<any>}
*/
  signup(credentials: any): Promise<any>;
/**
* Sign this connection in to a specific authentication scope
*
* ```js
* const token = await db.signin({
*     namespace: 'namespace',
*     database: 'database',
*     scope: 'user_scope',
*     email: 'john.doe@example.com',
*     password: 'password123'
* });
* ```
* @param {any} credentials
* @returns {Promise<any>}
*/
  signin(credentials: any): Promise<any>;
/**
* Invalidates the authentication for the current connection
*
* ```js
* await db.invalidate();
* ```
* @returns {Promise<void>}
*/
  invalidate(): Promise<void>;
/**
* Authenticates the current connection with a JWT token
*
* ```js
* await db.authenticate('<secret token>');
* ```
* @param {string} token
* @returns {Promise<void>}
*/
  authenticate(token: string): Promise<void>;
/**
* Run a SurrealQL query against the database
*
* ```js
* // Run a query without bindings
* const people = await db.query('SELECT * FROM person');
*
* // Run a query with bindings
* const people = await db.query('SELECT * FROM type::table($table)', { table: 'person' });
* ```
* @param {string} sql
* @param {any} bindings
* @returns {Promise<any>}
*/
  query(sql: string, bindings: any): Promise<any>;
/**
* Select all records in a table, or a specific record
*
* ```js
* // Select all records from a table
* const people = await db.select('person');
*
* // Select a range records from a table
* const people = await db.select('person:jane..john');
*
* // Select a specific record from a table
* const person = await db.select('person:h5wxrf2ewk8xjxosxtyc');
* ```
* @param {string} resource
* @returns {Promise<any>}
*/
  select(resource: string): Promise<any>;
/**
* Create a record in the database
*
* ```js
* // Create a record with no fields set
* const person = await db.create('person');
*
* Create a record with fields set
* const person = await db.create('person', {
*     name: 'Tobie',
*     settings: {
*         active: true,
*         marketing: true
*     }
* });
* ```
* @param {string} resource
* @param {any} data
* @returns {Promise<any>}
*/
  create(resource: string, data: any): Promise<any>;
/**
* Update all records in a table, or a specific record
*
* ```js
* // Replace all records in a table with the specified data.
* const people = await db.update('person', {
*     name: 'Tobie',
*     settings: {
*         active: true,
*         marketing: true
*     }
* });
*
* // Replace a range of records with the specified data.
* const person = await db.update('person:jane..john', {
*     name: 'Tobie',
*     settings: {
*         active: true,
*         marketing: true
*     }
* });
*
* // Replace the current document / record data with the specified data.
* const person = await db.update('person:tobie', {
*     name: 'Tobie',
*     settings: {
*         active: true,
*         marketing: true
*     }
* });
* ```
* @param {string} resource
* @param {any} data
* @returns {Promise<any>}
*/
  update(resource: string, data: any): Promise<any>;
/**
* Merge records in a table with specified data
*
* ```js
* // Merge all records in a table with specified data.
* const person = await db.merge('person', {
*     marketing: true
* });
*
* // Merge a range of records with the specified data.
* const person = await db.merge('person:jane..john', {
*     marketing: true
* });
*
* // Merge the current document / record data with the specified data.
* const person = await db.merge('person:tobie', {
*     marketing: true
* });
* ```
* @param {string} resource
* @param {any} data
* @returns {Promise<any>}
*/
  merge(resource: string, data: any): Promise<any>;
/**
* Patch all records in a table or a specific record
*
* ```js
* // Apply JSON Patch changes to all records in the database.
* const person = await db.patch('person', [{
*     op: 'replace',
*     path: '/settings/active',
*     value: false
* }]);
*
* // Apply JSON Patch to a range of records.
* const person = await db.patch('person:jane..john', [{
*     op: 'replace',
*     path: '/settings/active',
*     value: false
* }]);
*
* // Apply JSON Patch to a specific record.
* const person = await db.patch('person:tobie', [{
*     op: 'replace',
*     path: '/settings/active',
*     value: false
* }]);
* ```
* @param {string} resource
* @param {any} data
* @returns {Promise<any>}
*/
  patch(resource: string, data: any): Promise<any>;
/**
* Delete all records, or a specific record
*
* ```js
* // Delete all records from a table
* const records = await db.delete('person');
*
* // Delete a range records from a table
* const people = await db.delete('person:jane..john');
*
* // Delete a specific record from a table
* const record = await db.delete('person:h5wxrf2ewk8xjxosxtyc');
* ```
* @param {string} resource
* @returns {Promise<any>}
*/
  delete(resource: string): Promise<any>;
/**
* Return the version of the server
*
* ```js
* const version = await db.version();
* ```
* @returns {Promise<any>}
*/
  version(): Promise<any>;
/**
* Check whether the server is healthy or not
*
* ```js
* await db.health();
* ```
* @returns {Promise<void>}
*/
  health(): Promise<void>;
}

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly setup: () => void;
  readonly __wbg_surreal_free: (a: number) => void;
  readonly surreal_init: () => number;
  readonly surreal_connect: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_use: (a: number, b: number) => number;
  readonly surreal_set: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_unset: (a: number, b: number, c: number) => number;
  readonly surreal_signup: (a: number, b: number) => number;
  readonly surreal_signin: (a: number, b: number) => number;
  readonly surreal_invalidate: (a: number) => number;
  readonly surreal_authenticate: (a: number, b: number, c: number) => number;
  readonly surreal_query: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_select: (a: number, b: number, c: number) => number;
  readonly surreal_create: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_update: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_merge: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_patch: (a: number, b: number, c: number, d: number) => number;
  readonly surreal_delete: (a: number, b: number, c: number) => number;
  readonly surreal_version: (a: number) => number;
  readonly surreal_health: (a: number) => number;
  readonly __wbg_queuingstrategy_free: (a: number) => void;
  readonly queuingstrategy_highWaterMark: (a: number) => number;
  readonly __wbg_intounderlyingbytesource_free: (a: number) => void;
  readonly intounderlyingbytesource_type: (a: number, b: number) => void;
  readonly intounderlyingbytesource_autoAllocateChunkSize: (a: number) => number;
  readonly intounderlyingbytesource_start: (a: number, b: number) => void;
  readonly intounderlyingbytesource_pull: (a: number, b: number) => number;
  readonly __wbg_intounderlyingsource_free: (a: number) => void;
  readonly intounderlyingsource_pull: (a: number, b: number) => number;
  readonly intounderlyingsource_cancel: (a: number) => void;
  readonly __wbg_readablestreamgetreaderoptions_free: (a: number) => void;
  readonly readablestreamgetreaderoptions_mode: (a: number) => number;
  readonly __wbg_pipeoptions_free: (a: number) => void;
  readonly pipeoptions_preventClose: (a: number) => number;
  readonly pipeoptions_preventCancel: (a: number) => number;
  readonly pipeoptions_preventAbort: (a: number) => number;
  readonly pipeoptions_signal: (a: number) => number;
  readonly __wbg_intounderlyingsink_free: (a: number) => void;
  readonly intounderlyingsink_write: (a: number, b: number) => number;
  readonly intounderlyingsink_close: (a: number) => number;
  readonly intounderlyingsink_abort: (a: number, b: number) => number;
  readonly intounderlyingbytesource_cancel: (a: number) => void;
  readonly __wbindgen_export_0: (a: number, b: number) => number;
  readonly __wbindgen_export_1: (a: number, b: number, c: number, d: number) => number;
  readonly __wbindgen_export_2: WebAssembly.Table;
  readonly __wbindgen_export_3: (a: number, b: number, c: number) => void;
  readonly __wbindgen_add_to_stack_pointer: (a: number) => number;
  readonly __wbindgen_export_4: (a: number, b: number, c: number, d: number) => void;
  readonly __wbindgen_export_5: (a: number, b: number, c: number) => void;
  readonly __wbindgen_export_6: (a: number, b: number) => void;
  readonly __wbindgen_export_7: (a: number, b: number, c: number) => void;
  readonly __wbindgen_export_8: (a: number, b: number, c: number) => void;
  readonly __wbindgen_export_9: (a: number) => void;
  readonly __wbindgen_export_10: (a: number, b: number, c: number, d: number) => void;
  readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;
/**
* Instantiates the given `module`, which can either be bytes or
* a precompiled `WebAssembly.Module`.
*
* @param {SyncInitInput} module
*
* @returns {InitOutput}
*/
export function initSync(module: SyncInitInput): InitOutput;

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {InitInput | Promise<InitInput>} module_or_path
*
* @returns {Promise<InitOutput>}
*/
export default function __wbg_init (module_or_path?: InitInput | Promise<InitInput>): Promise<InitOutput>;
