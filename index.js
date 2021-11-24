const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("<h2>Hello, World!.</h2>");
});

const port = process.env.port || 3000;

app.listen(port, () => console.log(`listening on port ${port}`));
