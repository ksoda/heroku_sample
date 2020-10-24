const bsconfig = require("./bsconfig.json");
const withCSS = require("@zeit/next-css");

const withTM = require("next-transpile-modules")(
  ["bs-platform"].concat(bsconfig["bs-dependencies"])
);

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"]),
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.node = {
        fs: "empty",
      };
    }
    return config;
  },
};

module.exports = {
  ...withTM(withCSS(config)),
  // publicRuntimeConfig: {
  //   service_url: process.env.SERVICE_URL || "http://localhost:8080",
  // },
  trailingSlash: true,
};
