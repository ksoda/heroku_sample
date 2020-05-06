const jsf = require("json-schema-faker");
const schema = require("../schema.json");

console.log(JSON.stringify(jsf.generate(schema)));
