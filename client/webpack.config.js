const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require("path");

/** @type import('webpack').Configuration */
module.exports = {
  context: path.resolve(__dirname, "src"),
  entry: "./Main.bs.js",
  devServer: {
    overlay: true,
    progress: true,
    open: true,
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "index.html",
    }),
  ],
};
