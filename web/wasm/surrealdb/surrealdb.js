import init, { Surreal } from "./index.js";

if (typeof window !== "undefined") {
  window.Surreal = Surreal;
}

// Initialize the Wasm module
await init();
console.log("Surreal initialized!!!");
