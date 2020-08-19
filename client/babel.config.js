module.exports = (api) =>
  !api.env("test")
    ? {
        presets: ["next/babel"],
      }
    : {
        presets: [
          [
            "@babel/preset-env",
            {
              targets: {
                node: "current",
              },
            },
          ],
        ],
      };
