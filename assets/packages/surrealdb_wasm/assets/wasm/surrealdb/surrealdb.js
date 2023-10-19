// REF: https://stackoverflow.com/questions/46338176/javascript-reading-local-file-to-uint8array-fast

export async function loadWasm() {
  if (wasm !== undefined) return wasm;

  const input = new URL("surrealdb.wasm.gz", import.meta.url);
  const imports = __wbg_get_imports();

  const response = await fetch(input);

  __wbg_init_memory(imports);

  const data = new Uint8Array(await response.arrayBuffer());

  // Decompress the data using wasm-flate
  //const flate = await wasm_bindgen(
  //  "https://unpkg.com/wasm-flate/wasm_flate_bg.wasm"
  //);

  //const compressed_data = flate.gzip_encode_raw(data);
  //console.log("compressed_data", compressed_data);
  const decompressed_data = flate.gzip_decode_raw(data);
  console.log("decompressed_data", decompressed_data);
  const bytes = decompressed_data.buffer;

  const { instance, module } = await WebAssembly.instantiate(bytes, imports);

  return __wbg_finalize_init(instance, module);
}

class SurrealWrapper {
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
