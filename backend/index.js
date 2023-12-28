const express = require('express');
const cors = require('cors');
const db = require('./db');
const userRouter = require('./user');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;
//const ipAddress = 'localhost';
const ipAddress='192.168.1.9';

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors())
app.use(express.json({ limit: '1000mb' }));

app.use('/user', userRouter);


app.listen(port, ipAddress, () => {
    console.log(`Your Server has started on http://${ipAddress}:${port}`);
  });