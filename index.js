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

const connectWithRetry = () => {
  mongoose
    .connect(mongoURL, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => console.log("Successfully connected to database."))
    .catch((e) => {
      console.log(e);
      setTimeout(connectWithRetry, 5000);
    });
};

connectWithRetry();

app.get("/", (req, res) => {
  res.send("<h2>Hello, World!</h2>");
});

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`Listening on port ${port}.`));
