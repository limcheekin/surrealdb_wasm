let wasm;

const heap = new Array(128).fill(undefined);

heap.push(undefined, null, true, false);

function getObject(idx) { return heap[idx]; }

function isLikeNone(x) {
    return x === undefined || x === null;
}

let cachedFloat64Memory0 = null;

function getFloat64Memory0() {
    if (cachedFloat64Memory0 === null || cachedFloat64Memory0.byteLength === 0) {
        cachedFloat64Memory0 = new Float64Array(wasm.memory.buffer);
    }
    return cachedFloat64Memory0;
}

let cachedInt32Memory0 = null;

function getInt32Memory0() {
    if (cachedInt32Memory0 === null || cachedInt32Memory0.byteLength === 0) {
        cachedInt32Memory0 = new Int32Array(wasm.memory.buffer);
    }
    return cachedInt32Memory0;
}

let WASM_VECTOR_LEN = 0;

let cachedUint8Memory0 = null;

function getUint8Memory0() {
    if (cachedUint8Memory0 === null || cachedUint8Memory0.byteLength === 0) {
        cachedUint8Memory0 = new Uint8Array(wasm.memory.buffer);
    }
    return cachedUint8Memory0;
}

const cachedTextEncoder = (typeof TextEncoder !== 'undefined' ? new TextEncoder('utf-8') : { encode: () => { throw Error('TextEncoder not available') } } );

const encodeString = (typeof cachedTextEncoder.encodeInto === 'function'
    ? function (arg, view) {
    return cachedTextEncoder.encodeInto(arg, view);
}
    : function (arg, view) {
    const buf = cachedTextEncoder.encode(arg);
    view.set(buf);
    return {
        read: arg.length,
        written: buf.length
    };
});

function passStringToWasm0(arg, malloc, realloc) {

    if (realloc === undefined) {
        const buf = cachedTextEncoder.encode(arg);
        const ptr = malloc(buf.length, 1) >>> 0;
        getUint8Memory0().subarray(ptr, ptr + buf.length).set(buf);
        WASM_VECTOR_LEN = buf.length;
        return ptr;
    }

    let len = arg.length;
    let ptr = malloc(len, 1) >>> 0;

    const mem = getUint8Memory0();

    let offset = 0;

    for (; offset < len; offset++) {
        const code = arg.charCodeAt(offset);
        if (code > 0x7F) break;
        mem[ptr + offset] = code;
    }

    if (offset !== len) {
        if (offset !== 0) {
            arg = arg.slice(offset);
        }
        ptr = realloc(ptr, len, len = offset + arg.length * 3, 1) >>> 0;
        const view = getUint8Memory0().subarray(ptr + offset, ptr + len);
        const ret = encodeString(arg, view);

        offset += ret.written;
        ptr = realloc(ptr, len, offset, 1) >>> 0;
    }

    WASM_VECTOR_LEN = offset;
    return ptr;
}

let heap_next = heap.length;

function addHeapObject(obj) {
    if (heap_next === heap.length) heap.push(heap.length + 1);
    const idx = heap_next;
    heap_next = heap[idx];

    heap[idx] = obj;
    return idx;
}

const cachedTextDecoder = (typeof TextDecoder !== 'undefined' ? new TextDecoder('utf-8', { ignoreBOM: true, fatal: true }) : { decode: () => { throw Error('TextDecoder not available') } } );

if (typeof TextDecoder !== 'undefined') { cachedTextDecoder.decode(); };

function getStringFromWasm0(ptr, len) {
    ptr = ptr >>> 0;
    return cachedTextDecoder.decode(getUint8Memory0().subarray(ptr, ptr + len));
}

function dropObject(idx) {
    if (idx < 132) return;
    heap[idx] = heap_next;
    heap_next = idx;
}

function takeObject(idx) {
    const ret = getObject(idx);
    dropObject(idx);
    return ret;
}

let cachedBigInt64Memory0 = null;

function getBigInt64Memory0() {
    if (cachedBigInt64Memory0 === null || cachedBigInt64Memory0.byteLength === 0) {
        cachedBigInt64Memory0 = new BigInt64Array(wasm.memory.buffer);
    }
    return cachedBigInt64Memory0;
}

function debugString(val) {
    // primitive types
    const type = typeof val;
    if (type == 'number' || type == 'boolean' || val == null) {
        return  `${val}`;
    }
    if (type == 'string') {
        return `"${val}"`;
    }
    if (type == 'symbol') {
        const description = val.description;
        if (description == null) {
            return 'Symbol';
        } else {
            return `Symbol(${description})`;
        }
    }
    if (type == 'function') {
        const name = val.name;
        if (typeof name == 'string' && name.length > 0) {
            return `Function(${name})`;
        } else {
            return 'Function';
        }
    }
    // objects
    if (Array.isArray(val)) {
        const length = val.length;
        let debug = '[';
        if (length > 0) {
            debug += debugString(val[0]);
        }
        for(let i = 1; i < length; i++) {
            debug += ', ' + debugString(val[i]);
        }
        debug += ']';
        return debug;
    }
    // Test for built-in
    const builtInMatches = /\[object ([^\]]+)\]/.exec(toString.call(val));
    let className;
    if (builtInMatches.length > 1) {
        className = builtInMatches[1];
    } else {
        // Failed to match the standard '[object ClassName]'
        return toString.call(val);
    }
    if (className == 'Object') {
        // we're a user defined class or Object
        // JSON.stringify avoids problems with cycles, and is generally much
        // easier than looping through ownProperties of `val`.
        try {
            return 'Object(' + JSON.stringify(val) + ')';
        } catch (_) {
            return 'Object';
        }
    }
    // errors
    if (val instanceof Error) {
        return `${val.name}: ${val.message}\n${val.stack}`;
    }
    // TODO we could test for more things here, like `Set`s and `Map`s.
    return className;
}

const CLOSURE_DTORS = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(state => {
    wasm.__wbindgen_export_2.get(state.dtor)(state.a, state.b)
});

function makeMutClosure(arg0, arg1, dtor, f) {
    const state = { a: arg0, b: arg1, cnt: 1, dtor };
    const real = (...args) => {
        // First up with a closure we increment the internal reference
        // count. This ensures that the Rust closure environment won't
        // be deallocated while we're invoking it.
        state.cnt++;
        const a = state.a;
        state.a = 0;
        try {
            return f(a, state.b, ...args);
        } finally {
            if (--state.cnt === 0) {
                wasm.__wbindgen_export_2.get(state.dtor)(a, state.b);
                CLOSURE_DTORS.unregister(state);
            } else {
                state.a = a;
            }
        }
    };
    real.original = state;
    CLOSURE_DTORS.register(real, state, state);
    return real;
}
function __wbg_adapter_52(arg0, arg1, arg2) {
    wasm.__wbindgen_export_3(arg0, arg1, addHeapObject(arg2));
}

function __wbg_adapter_55(arg0, arg1, arg2) {
    wasm.__wbindgen_export_4(arg0, arg1, addHeapObject(arg2));
}

function __wbg_adapter_58(arg0, arg1, arg2) {
    try {
        const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
        wasm.__wbindgen_export_5(retptr, arg0, arg1, addHeapObject(arg2));
        var r0 = getInt32Memory0()[retptr / 4 + 0];
        var r1 = getInt32Memory0()[retptr / 4 + 1];
        if (r1) {
            throw takeObject(r0);
        }
    } finally {
        wasm.__wbindgen_add_to_stack_pointer(16);
    }
}

function __wbg_adapter_61(arg0, arg1, arg2) {
    wasm.__wbindgen_export_6(arg0, arg1, addHeapObject(arg2));
}

function __wbg_adapter_64(arg0, arg1) {
    wasm.__wbindgen_export_7(arg0, arg1);
}

/**
*/
export function setup() {
    wasm.setup();
}

function handleError(f, args) {
    try {
        return f.apply(this, args);
    } catch (e) {
        wasm.__wbindgen_export_9(addHeapObject(e));
    }
}

function getArrayU8FromWasm0(ptr, len) {
    ptr = ptr >>> 0;
    return getUint8Memory0().subarray(ptr / 1, ptr / 1 + len);
}
function __wbg_adapter_379(arg0, arg1, arg2, arg3) {
    wasm.__wbindgen_export_10(arg0, arg1, addHeapObject(arg2), addHeapObject(arg3));
}

const IntoUnderlyingByteSourceFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_intounderlyingbytesource_free(ptr >>> 0));
/**
*/
export class IntoUnderlyingByteSource {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        IntoUnderlyingByteSourceFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_intounderlyingbytesource_free(ptr);
    }
    /**
    * @returns {string}
    */
    get type() {
        let deferred1_0;
        let deferred1_1;
        try {
            const retptr = wasm.__wbindgen_add_to_stack_pointer(-16);
            wasm.intounderlyingbytesource_type(retptr, this.__wbg_ptr);
            var r0 = getInt32Memory0()[retptr / 4 + 0];
            var r1 = getInt32Memory0()[retptr / 4 + 1];
            deferred1_0 = r0;
            deferred1_1 = r1;
            return getStringFromWasm0(r0, r1);
        } finally {
            wasm.__wbindgen_add_to_stack_pointer(16);
            wasm.__wbindgen_export_8(deferred1_0, deferred1_1, 1);
        }
    }
    /**
    * @returns {number}
    */
    get autoAllocateChunkSize() {
        const ret = wasm.intounderlyingbytesource_autoAllocateChunkSize(this.__wbg_ptr);
        return ret >>> 0;
    }
    /**
    * @param {ReadableByteStreamController} controller
    */
    start(controller) {
        wasm.intounderlyingbytesource_start(this.__wbg_ptr, addHeapObject(controller));
    }
    /**
    * @param {ReadableByteStreamController} controller
    * @returns {Promise<any>}
    */
    pull(controller) {
        const ret = wasm.intounderlyingbytesource_pull(this.__wbg_ptr, addHeapObject(controller));
        return takeObject(ret);
    }
    /**
    */
    cancel() {
        const ptr = this.__destroy_into_raw();
        wasm.intounderlyingbytesource_cancel(ptr);
    }
}

const IntoUnderlyingSinkFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_intounderlyingsink_free(ptr >>> 0));
/**
*/
export class IntoUnderlyingSink {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        IntoUnderlyingSinkFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_intounderlyingsink_free(ptr);
    }
    /**
    * @param {any} chunk
    * @returns {Promise<any>}
    */
    write(chunk) {
        const ret = wasm.intounderlyingsink_write(this.__wbg_ptr, addHeapObject(chunk));
        return takeObject(ret);
    }
    /**
    * @returns {Promise<any>}
    */
    close() {
        const ptr = this.__destroy_into_raw();
        const ret = wasm.intounderlyingsink_close(ptr);
        return takeObject(ret);
    }
    /**
    * @param {any} reason
    * @returns {Promise<any>}
    */
    abort(reason) {
        const ptr = this.__destroy_into_raw();
        const ret = wasm.intounderlyingsink_abort(ptr, addHeapObject(reason));
        return takeObject(ret);
    }
}

const IntoUnderlyingSourceFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_intounderlyingsource_free(ptr >>> 0));
/**
*/
export class IntoUnderlyingSource {

    static __wrap(ptr) {
        ptr = ptr >>> 0;
        const obj = Object.create(IntoUnderlyingSource.prototype);
        obj.__wbg_ptr = ptr;
        IntoUnderlyingSourceFinalization.register(obj, obj.__wbg_ptr, obj);
        return obj;
    }

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        IntoUnderlyingSourceFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_intounderlyingsource_free(ptr);
    }
    /**
    * @param {ReadableStreamDefaultController} controller
    * @returns {Promise<any>}
    */
    pull(controller) {
        const ret = wasm.intounderlyingsource_pull(this.__wbg_ptr, addHeapObject(controller));
        return takeObject(ret);
    }
    /**
    */
    cancel() {
        const ptr = this.__destroy_into_raw();
        wasm.intounderlyingsource_cancel(ptr);
    }
}

const SurrealFinalization = (typeof FinalizationRegistry === 'undefined')
    ? { register: () => {}, unregister: () => {} }
    : new FinalizationRegistry(ptr => wasm.__wbg_surreal_free(ptr >>> 0));
/**
*/
export class Surreal {

    __destroy_into_raw() {
        const ptr = this.__wbg_ptr;
        this.__wbg_ptr = 0;
        SurrealFinalization.unregister(this);
        return ptr;
    }

    free() {
        const ptr = this.__destroy_into_raw();
        wasm.__wbg_surreal_free(ptr);
    }
    /**
    * Construct the database engine
    *
    * ```js
    * const db = new Surreal();
    * ```
    */
    constructor() {
        const ret = wasm.surreal_init();
        this.__wbg_ptr = ret >>> 0;
        return this;
    }
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
    * // Enable live query notifications
    * await db.connect('indxdb://MyDatabase', { capabilities: { live_query_notifications: true } });
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
    * @param {ConnectionOptions | undefined} [opts]
    * @returns {Promise<void>}
    */
    connect(endpoint, opts) {
        const ptr0 = passStringToWasm0(endpoint, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_connect(this.__wbg_ptr, ptr0, len0, isLikeNone(opts) ? 0 : addHeapObject(opts));
        return takeObject(ret);
    }
    /**
    * Switch to a specific namespace or database
    *
    * ```js
    * const db = new Surreal();
    *
    * // Switch to a namespace
    * await db.use({ namespace: 'namespace' });
    *
    * // Switch to a database
    * await db.use({ database: 'database' });
    *
    * // Switch both
    * await db.use({ namespace: 'namespace', database: 'database' });
    * ```
    * @param {UseOptions | undefined} [opts]
    * @returns {Promise<void>}
    */
    use(opts) {
        const ret = wasm.surreal_use(this.__wbg_ptr, isLikeNone(opts) ? 0 : addHeapObject(opts));
        return takeObject(ret);
    }
    /**
    * Assign a value as a parameter for this connection
    *
    * ```js
    * await db.set('name', { first: 'Tobie', last: 'Morgan Hitchcock' });
    * ```
    * @param {string} key
    * @param {unknown} value
    * @returns {Promise<void>}
    */
    set(key, value) {
        const ptr0 = passStringToWasm0(key, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_set(this.__wbg_ptr, ptr0, len0, addHeapObject(value));
        return takeObject(ret);
    }
    /**
    * Remove a parameter from this connection
    *
    * ```js
    * await db.unset('name');
    * ```
    * @param {string} key
    * @returns {Promise<void>}
    */
    unset(key) {
        const ptr0 = passStringToWasm0(key, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_unset(this.__wbg_ptr, ptr0, len0);
        return takeObject(ret);
    }
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
    * @param {ScopeUserAuth} credentials
    * @returns {Promise<string>}
    */
    signup(credentials) {
        const ret = wasm.surreal_signup(this.__wbg_ptr, addHeapObject(credentials));
        return takeObject(ret);
    }
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
    * @param {AnyAuth} credentials
    * @returns {Promise<string>}
    */
    signin(credentials) {
        const ret = wasm.surreal_signin(this.__wbg_ptr, addHeapObject(credentials));
        return takeObject(ret);
    }
    /**
    * Invalidates the authentication for the current connection
    *
    * ```js
    * await db.invalidate();
    * ```
    * @returns {Promise<void>}
    */
    invalidate() {
        const ret = wasm.surreal_invalidate(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * Authenticates the current connection with a JWT token
    *
    * ```js
    * await db.authenticate('<secret token>');
    * ```
    * @param {string} token
    * @returns {Promise<boolean>}
    */
    authenticate(token) {
        const ptr0 = passStringToWasm0(token, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_authenticate(this.__wbg_ptr, ptr0, len0);
        return takeObject(ret);
    }
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
    * @param {Record<string, unknown> | undefined} [bindings]
    * @returns {Promise<unknown[]>}
    */
    query(sql, bindings) {
        const ptr0 = passStringToWasm0(sql, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_query(this.__wbg_ptr, ptr0, len0, isLikeNone(bindings) ? 0 : addHeapObject(bindings));
        return takeObject(ret);
    }
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
    * @returns {Promise<Record<string, unknown>[]>}
    */
    select(resource) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_select(this.__wbg_ptr, ptr0, len0);
        return takeObject(ret);
    }
    /**
    * Live select all records in a table, or a specific record
    *
    * ```js
    * // Live select all records from a table
    * const stream = await db.live('person');
    *
    * // Live select a range records from a table
    * const stream = await db.live('person:jane..john');
    *
    * // Live select a specific record from a table
    * const stream = await db.live('person:jane');
    *
    * // Get a reader
    * const reader = stream.getReader();
    *
    * // Listen for changes
    * while (true) {
    *   // Read from the stream
    *   const {done, notification} = await reader.read();
    *
    *   // Do something with each notification
    *   console.log(notification);
    *
    *   // Exit the loop if done
    *   if (done) break;
    * }
    * ```
    * @param {string} resource
    * @returns {Promise<ReadableStream>}
    */
    live(resource) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_live(this.__wbg_ptr, ptr0, len0);
        return takeObject(ret);
    }
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
    * @param {Record<string, unknown> | undefined} [data]
    * @returns {Promise<Record<string, unknown>[]>}
    */
    create(resource, data) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_create(this.__wbg_ptr, ptr0, len0, isLikeNone(data) ? 0 : addHeapObject(data));
        return takeObject(ret);
    }
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
    * @param {Record<string, unknown> | undefined} [data]
    * @returns {Promise<Record<string, unknown>[]>}
    */
    update(resource, data) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_update(this.__wbg_ptr, ptr0, len0, isLikeNone(data) ? 0 : addHeapObject(data));
        return takeObject(ret);
    }
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
    * @param {Record<string, unknown>} data
    * @returns {Promise<Record<string, unknown>[]>}
    */
    merge(resource, data) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_merge(this.__wbg_ptr, ptr0, len0, addHeapObject(data));
        return takeObject(ret);
    }
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
    * @param {Patch[]} data
    * @returns {Promise<Record<string, unknown>[]>}
    */
    patch(resource, data) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_patch(this.__wbg_ptr, ptr0, len0, addHeapObject(data));
        return takeObject(ret);
    }
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
    * @returns {Promise<Record<string, unknown>[]>}
    */
    delete(resource) {
        const ptr0 = passStringToWasm0(resource, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len0 = WASM_VECTOR_LEN;
        const ret = wasm.surreal_delete(this.__wbg_ptr, ptr0, len0);
        return takeObject(ret);
    }
    /**
    * Return the version of the server
    *
    * ```js
    * const version = await db.version();
    * ```
    * @returns {Promise<string>}
    */
    version() {
        const ret = wasm.surreal_version(this.__wbg_ptr);
        return takeObject(ret);
    }
    /**
    * Check whether the server is healthy or not
    *
    * ```js
    * await db.health();
    * ```
    * @returns {Promise<void>}
    */
    health() {
        const ret = wasm.surreal_health(this.__wbg_ptr);
        return takeObject(ret);
    }
}

async function __wbg_load(module, imports) {
    if (typeof Response === 'function' && module instanceof Response) {
        if (typeof WebAssembly.instantiateStreaming === 'function') {
            try {
                return await WebAssembly.instantiateStreaming(module, imports);

            } catch (e) {
                if (module.headers.get('Content-Type') != 'application/wasm') {
                    console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                } else {
                    throw e;
                }
            }
        }

        const bytes = await module.arrayBuffer();
        return await WebAssembly.instantiate(bytes, imports);

    } else {
        const instance = await WebAssembly.instantiate(module, imports);

        if (instance instanceof WebAssembly.Instance) {
            return { instance, module };

        } else {
            return instance;
        }
    }
}

function __wbg_get_imports() {
    const imports = {};
    imports.wbg = {};
    imports.wbg.__wbindgen_is_undefined = function(arg0) {
        const ret = getObject(arg0) === undefined;
        return ret;
    };
    imports.wbg.__wbindgen_in = function(arg0, arg1) {
        const ret = getObject(arg0) in getObject(arg1);
        return ret;
    };
    imports.wbg.__wbindgen_number_get = function(arg0, arg1) {
        const obj = getObject(arg1);
        const ret = typeof(obj) === 'number' ? obj : undefined;
        getFloat64Memory0()[arg0 / 8 + 1] = isLikeNone(ret) ? 0 : ret;
        getInt32Memory0()[arg0 / 4 + 0] = !isLikeNone(ret);
    };
    imports.wbg.__wbindgen_boolean_get = function(arg0) {
        const v = getObject(arg0);
        const ret = typeof(v) === 'boolean' ? (v ? 1 : 0) : 2;
        return ret;
    };
    imports.wbg.__wbindgen_string_get = function(arg0, arg1) {
        const obj = getObject(arg1);
        const ret = typeof(obj) === 'string' ? obj : undefined;
        var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        var len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbindgen_is_bigint = function(arg0) {
        const ret = typeof(getObject(arg0)) === 'bigint';
        return ret;
    };
    imports.wbg.__wbindgen_is_object = function(arg0) {
        const val = getObject(arg0);
        const ret = typeof(val) === 'object' && val !== null;
        return ret;
    };
    imports.wbg.__wbindgen_bigint_from_i64 = function(arg0) {
        const ret = arg0;
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_bigint_from_u64 = function(arg0) {
        const ret = BigInt.asUintN(64, arg0);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_error_new = function(arg0, arg1) {
        const ret = new Error(getStringFromWasm0(arg0, arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_string_new = function(arg0, arg1) {
        const ret = getStringFromWasm0(arg0, arg1);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_jsval_eq = function(arg0, arg1) {
        const ret = getObject(arg0) === getObject(arg1);
        return ret;
    };
    imports.wbg.__wbindgen_object_drop_ref = function(arg0) {
        takeObject(arg0);
    };
    imports.wbg.__wbindgen_object_clone_ref = function(arg0) {
        const ret = getObject(arg0);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_jsval_loose_eq = function(arg0, arg1) {
        const ret = getObject(arg0) == getObject(arg1);
        return ret;
    };
    imports.wbg.__wbindgen_as_number = function(arg0) {
        const ret = +getObject(arg0);
        return ret;
    };
    imports.wbg.__wbg_String_b9412f8799faab3e = function(arg0, arg1) {
        const ret = String(getObject(arg1));
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbindgen_number_new = function(arg0) {
        const ret = arg0;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_getwithrefkey_edc2c8960f0f1191 = function(arg0, arg1) {
        const ret = getObject(arg0)[getObject(arg1)];
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_set_f975102236d3c502 = function(arg0, arg1, arg2) {
        getObject(arg0)[takeObject(arg1)] = takeObject(arg2);
    };
    imports.wbg.__wbindgen_cb_drop = function(arg0) {
        const obj = takeObject(arg0).original;
        if (obj.cnt-- == 1) {
            obj.a = 0;
            return true;
        }
        const ret = false;
        return ret;
    };
    imports.wbg.__wbindgen_is_string = function(arg0) {
        const ret = typeof(getObject(arg0)) === 'string';
        return ret;
    };
    imports.wbg.__wbg_fetch_55199a013c1dad65 = function(arg0) {
        const ret = fetch(getObject(arg0));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_sethighWaterMark_ea50ed3ec2143088 = function(arg0, arg1) {
        getObject(arg0).highWaterMark = arg1;
    };
    imports.wbg.__wbg_newwithintounderlyingsource_a03a82aa1bbbb292 = function(arg0, arg1) {
        const ret = new ReadableStream(IntoUnderlyingSource.__wrap(arg0), takeObject(arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_is_falsy = function(arg0) {
        const ret = !getObject(arg0);
        return ret;
    };
    imports.wbg.__wbg_new_abda76e883ba8a5f = function() {
        const ret = new Error();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_stack_658279fe44541cf6 = function(arg0, arg1) {
        const ret = getObject(arg1).stack;
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbg_error_f851667af71bcfc6 = function(arg0, arg1) {
        let deferred0_0;
        let deferred0_1;
        try {
            deferred0_0 = arg0;
            deferred0_1 = arg1;
            console.error(getStringFromWasm0(arg0, arg1));
        } finally {
            wasm.__wbindgen_export_8(deferred0_0, deferred0_1, 1);
        }
    };
    imports.wbg.__wbg_queueMicrotask_3cbae2ec6b6cd3d6 = function(arg0) {
        const ret = getObject(arg0).queueMicrotask;
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_is_function = function(arg0) {
        const ret = typeof(getObject(arg0)) === 'function';
        return ret;
    };
    imports.wbg.__wbg_queueMicrotask_481971b0d87f3dd4 = function(arg0) {
        queueMicrotask(getObject(arg0));
    };
    imports.wbg.__wbg_performance_1430613edb72ce03 = function(arg0) {
        const ret = getObject(arg0).performance;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_now_eab901b1d3b8a295 = function(arg0) {
        const ret = getObject(arg0).now();
        return ret;
    };
    imports.wbg.__wbg_setTimeout_fba1b48a90e30862 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).setTimeout(getObject(arg1), arg2);
        return ret;
    }, arguments) };
    imports.wbg.__wbg_now_393c46a41e4934fc = function() { return handleError(function () {
        const ret = Date.now();
        return ret;
    }, arguments) };
    imports.wbg.__wbg_crypto_d05b68a3572bb8ca = function(arg0) {
        const ret = getObject(arg0).crypto;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_process_b02b3570280d0366 = function(arg0) {
        const ret = getObject(arg0).process;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_versions_c1cb42213cedf0f5 = function(arg0) {
        const ret = getObject(arg0).versions;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_node_43b1089f407e4ec2 = function(arg0) {
        const ret = getObject(arg0).node;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_require_9a7e0f667ead4995 = function() { return handleError(function () {
        const ret = module.require;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_msCrypto_10fc94afee92bd76 = function(arg0) {
        const ret = getObject(arg0).msCrypto;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_randomFillSync_b70ccbdf4926a99d = function() { return handleError(function (arg0, arg1) {
        getObject(arg0).randomFillSync(takeObject(arg1));
    }, arguments) };
    imports.wbg.__wbg_getRandomValues_7e42b4fb8779dc6d = function() { return handleError(function (arg0, arg1) {
        getObject(arg0).getRandomValues(getObject(arg1));
    }, arguments) };
    imports.wbg.__wbg_signal_a61f78a3478fd9bc = function(arg0) {
        const ret = getObject(arg0).signal;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_new_0d76b0581eca6298 = function() { return handleError(function () {
        const ret = new AbortController();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_abort_2aa7521d5690750e = function(arg0) {
        getObject(arg0).abort();
    };
    imports.wbg.__wbg_instanceof_Blob_83ad3dd4c9c406f0 = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof Blob;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_newwithu8arraysequenceandoptions_366f462e1b363808 = function() { return handleError(function (arg0, arg1) {
        const ret = new Blob(getObject(arg0), getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_wasClean_8222e9acf5c5ad07 = function(arg0) {
        const ret = getObject(arg0).wasClean;
        return ret;
    };
    imports.wbg.__wbg_code_5ee5dcc2842228cd = function(arg0) {
        const ret = getObject(arg0).code;
        return ret;
    };
    imports.wbg.__wbg_reason_5ed6709323849cb1 = function(arg0, arg1) {
        const ret = getObject(arg1).reason;
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbg_code_bddcff79610894cf = function(arg0) {
        const ret = getObject(arg0).code;
        return ret;
    };
    imports.wbg.__wbg_length_9ae5daf9a690cba9 = function(arg0) {
        const ret = getObject(arg0).length;
        return ret;
    };
    imports.wbg.__wbg_contains_c65b44400b549286 = function(arg0, arg1, arg2) {
        const ret = getObject(arg0).contains(getStringFromWasm0(arg1, arg2));
        return ret;
    };
    imports.wbg.__wbg_get_910bbb94abdcf488 = function(arg0, arg1, arg2) {
        const ret = getObject(arg1)[arg2 >>> 0];
        var ptr1 = isLikeNone(ret) ? 0 : passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        var len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbg_target_2fc177e386c8b7b0 = function(arg0) {
        const ret = getObject(arg0).target;
        return isLikeNone(ret) ? 0 : addHeapObject(ret);
    };
    imports.wbg.__wbg_new_d4ab7daa4cb33d5f = function() { return handleError(function () {
        const ret = new FormData();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_append_056476f73715b602 = function() { return handleError(function (arg0, arg1, arg2, arg3) {
        getObject(arg0).append(getStringFromWasm0(arg1, arg2), getObject(arg3));
    }, arguments) };
    imports.wbg.__wbg_append_9fd018eae44ea54a = function() { return handleError(function (arg0, arg1, arg2, arg3, arg4, arg5) {
        getObject(arg0).append(getStringFromWasm0(arg1, arg2), getObject(arg3), getStringFromWasm0(arg4, arg5));
    }, arguments) };
    imports.wbg.__wbg_new_ab6fd82b10560829 = function() { return handleError(function () {
        const ret = new Headers();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_append_7bfcb4937d1d5e29 = function() { return handleError(function (arg0, arg1, arg2, arg3, arg4) {
        getObject(arg0).append(getStringFromWasm0(arg1, arg2), getStringFromWasm0(arg3, arg4));
    }, arguments) };
    imports.wbg.__wbg_key_7a534de95a1f5fbf = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).key;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_advance_e211280146391e9c = function() { return handleError(function (arg0, arg1) {
        getObject(arg0).advance(arg1 >>> 0);
    }, arguments) };
    imports.wbg.__wbg_continue_f1c3e0815924de62 = function() { return handleError(function (arg0) {
        getObject(arg0).continue();
    }, arguments) };
    imports.wbg.__wbg_value_86d3334f5075b232 = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).value;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_objectStoreNames_588b5924274239fd = function(arg0) {
        const ret = getObject(arg0).objectStoreNames;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_createObjectStore_f494613cd1a00d43 = function() { return handleError(function (arg0, arg1, arg2, arg3) {
        const ret = getObject(arg0).createObjectStore(getStringFromWasm0(arg1, arg2), getObject(arg3));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_deleteObjectStore_1732efdd0f8a351d = function() { return handleError(function (arg0, arg1, arg2) {
        getObject(arg0).deleteObjectStore(getStringFromWasm0(arg1, arg2));
    }, arguments) };
    imports.wbg.__wbg_transaction_b39e2665b40b6324 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).transaction(getObject(arg1), takeObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_instanceof_IdbFactory_c70f8c7294f93655 = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof IDBFactory;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_open_f0d7259fd7e689ce = function() { return handleError(function (arg0, arg1, arg2, arg3) {
        const ret = getObject(arg0).open(getStringFromWasm0(arg1, arg2), arg3 >>> 0);
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_open_a05198d687357536 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).open(getStringFromWasm0(arg1, arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_bound_25385469508e98c7 = function() { return handleError(function (arg0, arg1, arg2, arg3) {
        const ret = IDBKeyRange.bound(getObject(arg0), getObject(arg1), arg2 !== 0, arg3 !== 0);
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_indexNames_fd89e01c0b29fe18 = function(arg0) {
        const ret = getObject(arg0).indexNames;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_add_a3b44bfbb3d40345 = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).add(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_add_1dac52a28ed73a3a = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).add(getObject(arg1), getObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_createIndex_d786564b37de8e73 = function() { return handleError(function (arg0, arg1, arg2, arg3, arg4) {
        const ret = getObject(arg0).createIndex(getStringFromWasm0(arg1, arg2), getObject(arg3), getObject(arg4));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_delete_f60bba7d0ae59a4f = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).delete(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_deleteIndex_cbeab45ca61aff12 = function() { return handleError(function (arg0, arg1, arg2) {
        getObject(arg0).deleteIndex(getStringFromWasm0(arg1, arg2));
    }, arguments) };
    imports.wbg.__wbg_get_5361b64cac0d0826 = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).get(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_openCursor_30d58ae27a327629 = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).openCursor();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_openCursor_611b1e488c393dd8 = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).openCursor(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_openCursor_2df5d7cb6c41ac04 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).openCursor(getObject(arg1), takeObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_put_0a0d7ca0f7fa8f83 = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).put(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_put_22792e17580ca18b = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).put(getObject(arg1), getObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_setonupgradeneeded_ad7645373c7d5e1b = function(arg0, arg1) {
        getObject(arg0).onupgradeneeded = getObject(arg1);
    };
    imports.wbg.__wbg_result_6cedf5f78600a79c = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).result;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_error_685b20024dc2d6ca = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).error;
        return isLikeNone(ret) ? 0 : addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_transaction_9c6c3c7e1f9283c7 = function(arg0) {
        const ret = getObject(arg0).transaction;
        return isLikeNone(ret) ? 0 : addHeapObject(ret);
    };
    imports.wbg.__wbg_setonsuccess_632ce0a1460455c2 = function(arg0, arg1) {
        getObject(arg0).onsuccess = getObject(arg1);
    };
    imports.wbg.__wbg_setonerror_8479b33e7568a904 = function(arg0, arg1) {
        getObject(arg0).onerror = getObject(arg1);
    };
    imports.wbg.__wbg_setonabort_523135fd9168ae8b = function(arg0, arg1) {
        getObject(arg0).onabort = getObject(arg1);
    };
    imports.wbg.__wbg_setoncomplete_d8e4236665cbf1e2 = function(arg0, arg1) {
        getObject(arg0).oncomplete = getObject(arg1);
    };
    imports.wbg.__wbg_setonerror_da071ec94e148397 = function(arg0, arg1) {
        getObject(arg0).onerror = getObject(arg1);
    };
    imports.wbg.__wbg_abort_5e21246d2bf821aa = function() { return handleError(function (arg0) {
        getObject(arg0).abort();
    }, arguments) };
    imports.wbg.__wbg_objectStore_da468793bd9df17b = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).objectStore(getStringFromWasm0(arg1, arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_data_3ce7c145ca4fbcdc = function(arg0) {
        const ret = getObject(arg0).data;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_now_4e659b3d15f470d9 = function(arg0) {
        const ret = getObject(arg0).now();
        return ret;
    };
    imports.wbg.__wbg_byobRequest_72fca99f9c32c193 = function(arg0) {
        const ret = getObject(arg0).byobRequest;
        return isLikeNone(ret) ? 0 : addHeapObject(ret);
    };
    imports.wbg.__wbg_close_184931724d961ccc = function() { return handleError(function (arg0) {
        getObject(arg0).close();
    }, arguments) };
    imports.wbg.__wbg_view_7f0ce470793a340f = function(arg0) {
        const ret = getObject(arg0).view;
        return isLikeNone(ret) ? 0 : addHeapObject(ret);
    };
    imports.wbg.__wbg_respond_b1a43b2e3a06d525 = function() { return handleError(function (arg0, arg1) {
        getObject(arg0).respond(arg1 >>> 0);
    }, arguments) };
    imports.wbg.__wbg_close_a994f9425dab445c = function() { return handleError(function (arg0) {
        getObject(arg0).close();
    }, arguments) };
    imports.wbg.__wbg_enqueue_ea194723156c0cc2 = function() { return handleError(function (arg0, arg1) {
        getObject(arg0).enqueue(getObject(arg1));
    }, arguments) };
    imports.wbg.__wbg_newwithstrandinit_3fd6fba4083ff2d0 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = new Request(getStringFromWasm0(arg0, arg1), getObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_instanceof_Response_849eb93e75734b6e = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof Response;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_url_5f6dc4009ac5f99d = function(arg0, arg1) {
        const ret = getObject(arg1).url;
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbg_status_61a01141acd3cf74 = function(arg0) {
        const ret = getObject(arg0).status;
        return ret;
    };
    imports.wbg.__wbg_headers_9620bfada380764a = function(arg0) {
        const ret = getObject(arg0).headers;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_arrayBuffer_29931d52c7206b02 = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).arrayBuffer();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_text_450a059667fd91fd = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).text();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_url_1ac02c9add50c527 = function(arg0, arg1) {
        const ret = getObject(arg1).url;
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbg_readyState_1c157e4ea17c134a = function(arg0) {
        const ret = getObject(arg0).readyState;
        return ret;
    };
    imports.wbg.__wbg_setonopen_ce7a4c51e5cf5788 = function(arg0, arg1) {
        getObject(arg0).onopen = getObject(arg1);
    };
    imports.wbg.__wbg_setonerror_39a785302b0cd2e9 = function(arg0, arg1) {
        getObject(arg0).onerror = getObject(arg1);
    };
    imports.wbg.__wbg_setonclose_b9929b1c1624dff3 = function(arg0, arg1) {
        getObject(arg0).onclose = getObject(arg1);
    };
    imports.wbg.__wbg_setonmessage_2af154ce83a3dc94 = function(arg0, arg1) {
        getObject(arg0).onmessage = getObject(arg1);
    };
    imports.wbg.__wbg_setbinaryType_b0cf5103cd561959 = function(arg0, arg1) {
        getObject(arg0).binaryType = takeObject(arg1);
    };
    imports.wbg.__wbg_new_6c74223c77cfabad = function() { return handleError(function (arg0, arg1) {
        const ret = new WebSocket(getStringFromWasm0(arg0, arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_newwithstrsequence_9bc178264d955680 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = new WebSocket(getStringFromWasm0(arg0, arg1), getObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_close_acd9532ff5c093ea = function() { return handleError(function (arg0) {
        getObject(arg0).close();
    }, arguments) };
    imports.wbg.__wbg_send_70603dff16b81b66 = function() { return handleError(function (arg0, arg1, arg2) {
        getObject(arg0).send(getStringFromWasm0(arg1, arg2));
    }, arguments) };
    imports.wbg.__wbg_send_5fcd7bab9777194e = function() { return handleError(function (arg0, arg1, arg2) {
        getObject(arg0).send(getArrayU8FromWasm0(arg1, arg2));
    }, arguments) };
    imports.wbg.__wbg_fetch_921fad6ef9e883dd = function(arg0, arg1) {
        const ret = getObject(arg0).fetch(getObject(arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_debug_5fb96680aecf5dc8 = function(arg0) {
        console.debug(getObject(arg0));
    };
    imports.wbg.__wbg_error_8e3928cfb8a43e2b = function(arg0) {
        console.error(getObject(arg0));
    };
    imports.wbg.__wbg_info_530a29cb2e4e3304 = function(arg0) {
        console.info(getObject(arg0));
    };
    imports.wbg.__wbg_log_5bb5f88f245d7762 = function(arg0) {
        console.log(getObject(arg0));
    };
    imports.wbg.__wbg_warn_63bbae1730aead09 = function(arg0) {
        console.warn(getObject(arg0));
    };
    imports.wbg.__wbg_self_ce0dbfc45cf2f5be = function() { return handleError(function () {
        const ret = self.self;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_window_c6fb939a7f436783 = function() { return handleError(function () {
        const ret = window.window;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_globalThis_d1e6af4856ba331b = function() { return handleError(function () {
        const ret = globalThis.globalThis;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_global_207b558942527489 = function() { return handleError(function () {
        const ret = global.global;
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_newnoargs_e258087cd0daa0ea = function(arg0, arg1) {
        const ret = new Function(getStringFromWasm0(arg0, arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_length_cd7af8117672b8b8 = function(arg0) {
        const ret = getObject(arg0).length;
        return ret;
    };
    imports.wbg.__wbg_new_16b304a2cfa7ff4a = function() {
        const ret = new Array();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_new_d9bc3a0147634640 = function() {
        const ret = new Map();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_next_40fc327bfc8770e6 = function(arg0) {
        const ret = getObject(arg0).next;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_value_d93c65011f51a456 = function(arg0) {
        const ret = getObject(arg0).value;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_iterator_2cee6dadfd956dfa = function() {
        const ret = Symbol.iterator;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_new_72fb9a18b5ae2624 = function() {
        const ret = new Object();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_get_bd8e338fbd5f5cc8 = function(arg0, arg1) {
        const ret = getObject(arg0)[arg1 >>> 0];
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_set_d4638f722068f043 = function(arg0, arg1, arg2) {
        getObject(arg0)[arg1 >>> 0] = takeObject(arg2);
    };
    imports.wbg.__wbg_isArray_2ab64d95e09ea0ae = function(arg0) {
        const ret = Array.isArray(getObject(arg0));
        return ret;
    };
    imports.wbg.__wbg_push_a5b05aedc7234f9f = function(arg0, arg1) {
        const ret = getObject(arg0).push(getObject(arg1));
        return ret;
    };
    imports.wbg.__wbg_instanceof_ArrayBuffer_836825be07d4c9d2 = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof ArrayBuffer;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_new_28c511d9baebfa89 = function(arg0, arg1) {
        const ret = new Error(getStringFromWasm0(arg0, arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_toString_ffe4c9ea3b3532e9 = function(arg0) {
        const ret = getObject(arg0).toString();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_call_27c0f87801dedf93 = function() { return handleError(function (arg0, arg1) {
        const ret = getObject(arg0).call(getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_call_b3ca7c6051f9bec1 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = getObject(arg0).call(getObject(arg1), getObject(arg2));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_instanceof_Map_87917e0a7aaf4012 = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof Map;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_set_8417257aaedc936b = function(arg0, arg1, arg2) {
        const ret = getObject(arg0).set(getObject(arg1), getObject(arg2));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_next_196c84450b364254 = function() { return handleError(function (arg0) {
        const ret = getObject(arg0).next();
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_done_298b57d23c0fc80c = function(arg0) {
        const ret = getObject(arg0).done;
        return ret;
    };
    imports.wbg.__wbg_isSafeInteger_f7b04ef02296c4d2 = function(arg0) {
        const ret = Number.isSafeInteger(getObject(arg0));
        return ret;
    };
    imports.wbg.__wbg_getTime_2bc4375165f02d15 = function(arg0) {
        const ret = getObject(arg0).getTime();
        return ret;
    };
    imports.wbg.__wbg_getTimezoneOffset_38257122e236c190 = function(arg0) {
        const ret = getObject(arg0).getTimezoneOffset();
        return ret;
    };
    imports.wbg.__wbg_new_cf3ec55744a78578 = function(arg0) {
        const ret = new Date(getObject(arg0));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_new0_7d84e5b2cd9fdc73 = function() {
        const ret = new Date();
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_now_3014639a94423537 = function() {
        const ret = Date.now();
        return ret;
    };
    imports.wbg.__wbg_entries_95cc2c823b285a09 = function(arg0) {
        const ret = Object.entries(getObject(arg0));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_get_e3c254076557e348 = function() { return handleError(function (arg0, arg1) {
        const ret = Reflect.get(getObject(arg0), getObject(arg1));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_has_0af94d20077affa2 = function() { return handleError(function (arg0, arg1) {
        const ret = Reflect.has(getObject(arg0), getObject(arg1));
        return ret;
    }, arguments) };
    imports.wbg.__wbg_set_1f9b04f170055d33 = function() { return handleError(function (arg0, arg1, arg2) {
        const ret = Reflect.set(getObject(arg0), getObject(arg1), getObject(arg2));
        return ret;
    }, arguments) };
    imports.wbg.__wbg_buffer_12d079cc21e14bdb = function(arg0) {
        const ret = getObject(arg0).buffer;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_stringify_8887fe74e1c50d81 = function() { return handleError(function (arg0) {
        const ret = JSON.stringify(getObject(arg0));
        return addHeapObject(ret);
    }, arguments) };
    imports.wbg.__wbg_new_81740750da40724f = function(arg0, arg1) {
        try {
            var state0 = {a: arg0, b: arg1};
            var cb0 = (arg0, arg1) => {
                const a = state0.a;
                state0.a = 0;
                try {
                    return __wbg_adapter_379(a, state0.b, arg0, arg1);
                } finally {
                    state0.a = a;
                }
            };
            const ret = new Promise(cb0);
            return addHeapObject(ret);
        } finally {
            state0.a = state0.b = 0;
        }
    };
    imports.wbg.__wbg_resolve_b0083a7967828ec8 = function(arg0) {
        const ret = Promise.resolve(getObject(arg0));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_then_0c86a60e8fcfe9f6 = function(arg0, arg1) {
        const ret = getObject(arg0).then(getObject(arg1));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_then_a73caa9a87991566 = function(arg0, arg1, arg2) {
        const ret = getObject(arg0).then(getObject(arg1), getObject(arg2));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_newwithbyteoffsetandlength_aa4a17c33a06e5cb = function(arg0, arg1, arg2) {
        const ret = new Uint8Array(getObject(arg0), arg1 >>> 0, arg2 >>> 0);
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_new_63b92bc8671ed464 = function(arg0) {
        const ret = new Uint8Array(getObject(arg0));
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_instanceof_Uint8Array_2b3bbecd033d19f6 = function(arg0) {
        let result;
        try {
            result = getObject(arg0) instanceof Uint8Array;
        } catch (_) {
            result = false;
        }
        const ret = result;
        return ret;
    };
    imports.wbg.__wbg_newwithlength_e9b4878cebadb3d3 = function(arg0) {
        const ret = new Uint8Array(arg0 >>> 0);
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_buffer_dd7f74bc60f1faab = function(arg0) {
        const ret = getObject(arg0).buffer;
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_subarray_a1f73cd4b5b42fe1 = function(arg0, arg1, arg2) {
        const ret = getObject(arg0).subarray(arg1 >>> 0, arg2 >>> 0);
        return addHeapObject(ret);
    };
    imports.wbg.__wbg_length_c20a40f15020d68a = function(arg0) {
        const ret = getObject(arg0).length;
        return ret;
    };
    imports.wbg.__wbg_byteLength_58f7b4fab1919d44 = function(arg0) {
        const ret = getObject(arg0).byteLength;
        return ret;
    };
    imports.wbg.__wbg_byteOffset_81d60f7392524f62 = function(arg0) {
        const ret = getObject(arg0).byteOffset;
        return ret;
    };
    imports.wbg.__wbg_set_a47bac70306a19a7 = function(arg0, arg1, arg2) {
        getObject(arg0).set(getObject(arg1), arg2 >>> 0);
    };
    imports.wbg.__wbindgen_bigint_get_as_i64 = function(arg0, arg1) {
        const v = getObject(arg1);
        const ret = typeof(v) === 'bigint' ? v : undefined;
        getBigInt64Memory0()[arg0 / 8 + 1] = isLikeNone(ret) ? BigInt(0) : ret;
        getInt32Memory0()[arg0 / 4 + 0] = !isLikeNone(ret);
    };
    imports.wbg.__wbindgen_debug_string = function(arg0, arg1) {
        const ret = debugString(getObject(arg1));
        const ptr1 = passStringToWasm0(ret, wasm.__wbindgen_export_0, wasm.__wbindgen_export_1);
        const len1 = WASM_VECTOR_LEN;
        getInt32Memory0()[arg0 / 4 + 1] = len1;
        getInt32Memory0()[arg0 / 4 + 0] = ptr1;
    };
    imports.wbg.__wbindgen_throw = function(arg0, arg1) {
        throw new Error(getStringFromWasm0(arg0, arg1));
    };
    imports.wbg.__wbindgen_memory = function() {
        const ret = wasm.memory;
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_closure_wrapper15865 = function(arg0, arg1, arg2) {
        const ret = makeMutClosure(arg0, arg1, 224, __wbg_adapter_52);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_closure_wrapper19400 = function(arg0, arg1, arg2) {
        const ret = makeMutClosure(arg0, arg1, 597, __wbg_adapter_55);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_closure_wrapper30894 = function(arg0, arg1, arg2) {
        const ret = makeMutClosure(arg0, arg1, 1543, __wbg_adapter_58);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_closure_wrapper35535 = function(arg0, arg1, arg2) {
        const ret = makeMutClosure(arg0, arg1, 1953, __wbg_adapter_61);
        return addHeapObject(ret);
    };
    imports.wbg.__wbindgen_closure_wrapper35852 = function(arg0, arg1, arg2) {
        const ret = makeMutClosure(arg0, arg1, 1986, __wbg_adapter_64);
        return addHeapObject(ret);
    };

    return imports;
}

function __wbg_init_memory(imports, maybe_memory) {

}

function __wbg_finalize_init(instance, module) {
    wasm = instance.exports;
    __wbg_init.__wbindgen_wasm_module = module;
    cachedBigInt64Memory0 = null;
    cachedFloat64Memory0 = null;
    cachedInt32Memory0 = null;
    cachedUint8Memory0 = null;

    wasm.__wbindgen_start();
    return wasm;
}

function initSync(module) {
    if (wasm !== undefined) return wasm;

    const imports = __wbg_get_imports();

    __wbg_init_memory(imports);

    if (!(module instanceof WebAssembly.Module)) {
        module = new WebAssembly.Module(module);
    }

    const instance = new WebAssembly.Instance(module, imports);

    return __wbg_finalize_init(instance, module);
}

async function __wbg_init(input) {
    if (wasm !== undefined) return wasm;

    if (typeof input === 'undefined') {
        input = new URL('index_bg.wasm', import.meta.url);
    }
    const imports = __wbg_get_imports();

    if (typeof input === 'string' || (typeof Request === 'function' && input instanceof Request) || (typeof URL === 'function' && input instanceof URL)) {
        input = fetch(input);
    }

    __wbg_init_memory(imports);

    const { instance, module } = await __wbg_load(await input, imports);

    return __wbg_finalize_init(instance, module);
}

export { initSync }
export default __wbg_init;

import * as fflate from "https://cdn.skypack.dev/fflate@0.8.0?min";

// REF: https://stackoverflow.com/questions/46338176/javascript-reading-local-file-to-uint8array-fast
(async function loadWasm() {
  if (wasm !== undefined) return wasm;

  const input = new URL("surrealdb.wasm.gz", import.meta.url);
  const imports = __wbg_get_imports();
  const response = await fetch(input);

  __wbg_init_memory(imports);

  const data = new Uint8Array(await response.arrayBuffer());
  const decompressed_data = fflate.gunzipSync(data);
  const bytes = decompressed_data.buffer;

  const { instance, module } = await WebAssembly.instantiate(bytes, imports);

  console.log("Surreal had been initialized!");

  return __wbg_finalize_init(instance, module);
})();

class SurrealWrapper {
  async set(key, value) {
    await this.db.set(key, JSON.parse(value));
  }

  async unset(key) {
    await this.db.unset(key);
  }

  async signup(credentials) {
    return await this.db.signup(JSON.parse(credentials));
  }

  async signin(credentials) {
    return await this.db.signin(JSON.parse(credentials));
  }

  async invalidate() {
    await this.db.invalidate();
  }

  async authenticate(token) {
    await this.db.authenticate(token);
  }

  async patch(resource, data) {
    return await this.db.patch(resource, JSON.parse(data));
  }

  async version() {
    return await this.db.version();
  }

  async health() {
    await this.db.health();
  }
  /**
   * Construct the database engine
   *
   * ```js
   * const db = new SurrealDB();
   * ```
   */
  constructor() {
    this.db = new Surreal();
    Object.freeze(this);
  }

  /* @param {string} endpoint
   * @param {any} opts
   * @returns {Promise<void>}
   */
  async connect(endpoint, opts) {
    const options = typeof opts == "string" ? JSON.parse(opts) : opts;
    await this.db.connect(endpoint, options);
  }

  /**
   * @param {any} value
   * @returns {Promise<void>}
   */
  // await db.use({ ns: "test", db: "test" });
  async use(value) {
    const nsdb = typeof value == "string" ? JSON.parse(value) : value;
    await this.db.use(nsdb);
  }

  /**
   * @param {string} resource
   * @param {any} data
   * @returns {Promise<any>}
   */
  async create(resource, data) {
    const value = typeof data == "string" ? JSON.parse(data) : data;
    console.log("surrealdb.js create() value", value);
    const result = await this.db.create(resource, value);
    console.log("surrealdb.js create()", result);
    return result;
  }

  /**
   * @param {string} resource
   * @param {any} data
   * @returns {Promise<any>}
   */
  async update(resource, data) {
    const value = typeof data == "string" ? JSON.parse(data) : data;
    const result = await this.db.update(resource, value);
    console.log("surrealdb.js update()", result);
    return result;
  }

  /**
   * @param {string} resource
   * @param {any} data
   * @returns {Promise<any>}
   */
  async merge(resource, data) {
    const value = typeof data == "string" ? JSON.parse(data) : data;
    const result = await this.db.merge(resource, value);
    console.log("surrealdb.js merge()", result);
    return result;
  }
  /**
   * @param {string} resource
   * @returns {Promise<any>}
   */
  async select(resource) {
    const result = await this.db.select(resource);
    console.log("surrealdb.js select()", result);
    return result;
  }

  /**
   * @param {string} sql
   * @param {any} bindings
   * @returns {Promise<any>}
   */
  async query(sql, bindings) {
    console.log("surrealdb.js query()", sql, bindings);
    const bindings_value =
      typeof bindings == "string" ? JSON.parse(bindings) : bindings;
    console.log("surrealdb.js query() bindings_value", bindings_value);
    const result = await this.db.query(sql, bindings_value);
    console.log("surrealdb.js query() result", result);
    return result;
  }

  /**
   * @param {string} resource
   * @returns {Promise<any>}
   */
  async delete(resource) {
    const result = await this.db.delete(resource);
    console.log("surrealdb.js delete()", result);
    return result;
  }
}

if (typeof window !== "undefined") {
  window.SurrealWrapper = SurrealWrapper;
}
