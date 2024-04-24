require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const port = 4000;
const userRoutes = require("./routes/users");
const healthRoutes = require("./routes/health");
const emotionRoutes = require("./routes/emotions");
const chatRoutes = require("./routes/chat");

app.use(cors());
app.use(bodyParser.json());
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send('Something broke!')
})

app.use("/api/users", userRoutes);
app.use("/api/health", healthRoutes);
app.use("/api/emotions", emotionRoutes);
app.use("/api/chats", chatRoutes);

app.use((err, req, res, next) => {
    const statusCode = err.statusCode || 500;
    console.error(err.message, err.stack);
    res.status(statusCode).json({ message: err.message });
  
    return;
  });


app.listen(port, () => {
    console.log(`Servidor en ejecución en http://localhost:${port}`);
});
