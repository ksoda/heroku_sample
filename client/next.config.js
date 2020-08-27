const withTM = require("next-transpile-modules")(["bs-platform"]);

module.exports = {
  ...withTM({
    pageExtensions: ["jsx", "js", "bs.js"],
  }),
  publicRuntimeConfig: {
    service_url: process.env.SERVICE_URL || "http://localhost:8080",
  },
  trailingSlash: true,
};
