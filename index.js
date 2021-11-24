const express = require("express");
const mongoose = require("mongoose");
const {
  DATABASE_NAME,
  DATABASE_USER,
  DATABASE_PASSWORD,
  DATABASE_IP,
  DATABASE_PORT,
} = require("./config/config");

const app = express();

const mongoURL = `${DATABASE_NAME}://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_IP}:${DATABASE_PORT}/?authSource=admin`;

mongoose
  .connect(mongoURL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Successfully connected to Database."))
  .catch((e) => console.log(e));

app.get("/", (req, res) => {
  res.send("<h2>Hello, World!</h2>");
});

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`Listening on port ${port}`));
