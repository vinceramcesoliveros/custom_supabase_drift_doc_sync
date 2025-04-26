// WASM interop functions for Dart

// Define the dart namespace if it doesn't exist
window.dart = window.dart || {};

// Provide implementations for required imports
window.dart.localtime = function() {
  console.log("dart.localtime called");
  return Math.floor(Date.now() / 1000);
};

window.dart.timezone = function() {
  console.log("dart.timezone called");
  return Intl.DateTimeFormat().resolvedOptions().timeZone || "UTC";
};

// Additional helpers for SQLite
window.sqlite3InitModule = window.sqlite3InitModule || function() {
  console.log("sqlite3InitModule polyfill called");
  return Promise.resolve({});
};

// Log when the interop script is loaded
console.log("WASM interop script loaded");