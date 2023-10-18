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
