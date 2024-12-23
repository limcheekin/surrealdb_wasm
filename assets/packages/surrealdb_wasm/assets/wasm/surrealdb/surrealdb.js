// REF: https://stackoverflow.com/questions/46338176/javascript-reading-local-file-to-uint8array-fast
async function fetchWasm() {
  const input = new URL("surrealdb.wasm.gz", import.meta.url);
  const response = await fetch(input);
  const data = new Uint8Array(await response.arrayBuffer());
  const decompressed_data = fflate.gunzipSync(data);
  const bytes = decompressed_data.buffer;
  return bytes;
}
