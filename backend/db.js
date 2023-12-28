const express = require('express');
var mysql = require('mysql2');

var connection = mysql.createConnection({
    host:'localhost',
    user:'root',
    password:'Tarun@1511',
    port:'3306',
    database:'b2bnetwork'
});

connection.connect(function(err) {
    if (err) {
        console.error('Error connecting to the database:', err);
        throw err;  // You might want to handle this differently based on your application requirements
    }
    console.log('Database connected');
});

module.exports = connection;