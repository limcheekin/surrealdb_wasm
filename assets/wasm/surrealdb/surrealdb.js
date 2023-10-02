import init, { Surreal } from "./index.js";

// Initialize the Wasm module
await init();
console.log("Surreal initialized!!!");

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
    await this.db.connect(endpoint, opts);
  }

  /**
   * @param {any} value
   * @returns {Promise<void>}
   */
  // await db.use({ ns: "test", db: "test" });
  async use(value) {
    await this.db.use(value);
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
    const result = await this.db.query(sql, bindings);
    console.log("surrealdb.js query()", result);
    return result;
  }
}

if (typeof window !== "undefined") {
  window.SurrealWrapper = SurrealWrapper;
}

/* Sample codes 

try {
  // Connect to the database
  // https://github.com/surrealdb/surrealdb.wasm/issues/3#issuecomment-1264377954

  // Signin as a namespace, database, or root user
  //await db.signin({
  //	username: "root",
  //	password: "root",
  //});

  // Select a specific namespace / database
  await db.use({ ns: "test", db: "test" });

  // Create a new person with a random id
  /*let created = await db.create("person", {
    title: "Founder & CEO",
    name: {
      first: "Tobie",
      last: "Morgan Hitchcock",
    },
    marketing: true,
    identifier: Math.random().toString(36).substr(2, 10),
  });
  console.log("created", created);

  // Update a person record with a specific id
  let updated = await db.merge("person:jaime", {
    marketing: true,
  });
  console.log("updated", updated);

  // Select all people records
  let people = await db.select("person");
  console.log("people", people);

  // Perform a custom advanced query
  let groups = await db.query(
    "SELECT marketing, count() FROM type::table($table) GROUP BY marketing",
    {
      table: "person",
    }
  );
  console.log("groups", groups);

  // Delete all people upto but not including Jaime
  let deleted = await db.delete("person:..jaime");
  console.log("deleted", deleted);

  // Delete all people
  await db.delete("person");

  // REF: https://surrealdb.com/docs/surrealql/functions/vector
  //		https://github.com/surrealdb/surrealdb/issues/1903
  let cos = await db.query(
    "RETURN vector::similarity::cosine([1,2,3],[4,5,6])"
  );
  console.log("cos", cos);
} catch (e) {
  console.error("ERROR", e);
}
*/
