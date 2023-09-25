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

  /**
   * @param {string} endpoint
   * @param {string} opts: JSON string
   * @returns {void}
   */
  async connect(endpoint, opts) {
    if (opts) {
      opts = JSON.parse(opts);
    }
    await this.db.connect(endpoint, opts);
  }

  /**
   * @param {string} value: JSON string
   * @returns {void}
   */
  // await db.use({ ns: "test", db: "test" });
  async use(value) {
    value = JSON.parse(value);
    await this.db.use(value);
  }

  /**
   * @param {string} resource
   * @param {string} data: JSON string
   * @returns {string} JSON string
   */
  async create(resource, data) {
    const result = await this.db.create(resource, JSON.parse(data));
    console.log("surrealdb.js create()", result);
    return JSON.stringify(result);
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
