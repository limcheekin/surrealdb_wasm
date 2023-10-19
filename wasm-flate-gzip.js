const flate = require("wasm-flate");
const fs = require("fs");

// Check if the required command line arguments are provided
if (process.argv.length < 4) {
  console.error("Usage: node gzip.js <inputFile> <outputGzipFile>");
  process.exit(1);
}

const inputFile = process.argv[2];
const outputGzipFile = process.argv[3];

const data = fs.readFileSync(inputFile);
const compressedData = flate.gzip_encode_raw(data);
fs.writeFileSync(outputGzipFile, compressedData);

console.log("File compression completed.");
