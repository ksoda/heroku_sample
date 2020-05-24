const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");

module.exports = (env, argv) => {
  /** @type import('webpack').Configuration */
  const settings = {
    context: path.resolve(__dirname, "src"),
    entry: "./Main.bs.js",
    devServer: {
      overlay: true,
      progress: true,
      open: true,
    },
    plugins: [
      new HtmlWebpackPlugin({
        template: "index.ejs",
        templateParameters: {
          service: JSON.stringify(
            argv.mode === "production"
              ? process.env.SERVICE_URL
              : "http://localhost:3000"
          ),
        },
      }),
    ],
  };
  return settings;
};
