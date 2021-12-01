const express = require("express");
const mongoose = require("mongoose");
const session = require("express-session");
const redis = require("redis");

let RedisStore = require("connect-redis")(session);

const {
  DATABASE_NAME,
  DATABASE_USER,
  DATABASE_PASSWORD,
  DATABASE_IP,
  DATABASE_PORT,
  AUTH_PORT,
  AUTH_URL,
  SESSION_SECRET,
} = require("./config/config");

let redisClient = redis.createClient({
  host: AUTH_URL,
  port: AUTH_PORT,
});

const postRouter = require("./routes/postRoutes");
const userRouter = require("./routes/userRoutes");

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

// Middleware
app.use(
  session({
    store: new RedisStore({ client: redisClient }),
    secret: SESSION_SECRET,
    resave: true,
    saveUninitialized: true,
    cookie: {
      secure: false,
      httpOnly: true,
      maxAge: 3000000,
    },
  })
);

app.use(express.json());

// Route
app.get("/", (req, res) => {
  res.send("<h2>Hello, World.</h2>");
});

// localhost:3000/api/v1/posts
app.use("/api/v1/posts", postRouter);
app.use("/api/v1/users", userRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`Listening on port ${port}.`));
