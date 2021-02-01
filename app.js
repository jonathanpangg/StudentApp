var express = require('express')
var app = express()
var mongodb = require('mongodb')
var assert = require('assert')
var db = require('./mongoose')  
const url = 'https://heroku-studentapp.herokuapp.com'
var users = []
app.use(express.json())

app.get('/users', (req, res) => {
    var resultArray = []
    mongodb.connect(port, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('Users').find({}).toArray(function(err, result) {
            if (error) throw error
            res.send(result)
            resultArray = result
            console.log(resultArray)
            db.close()
        })
    })
})

function getUsers() {
    var resultArray = []
    app.get('/users', (req, res) => {
        mongodb.connect(port, function (error, db) {
            if (error) throw error;
            var dbo = db.db('StudentApp')
            dbo.collection('Users').find({}).toArray(function(err, result) {
                if (error) throw error
                resultArray = result
                db.close()
            })
        })
    })
    return resultArray
}

// /GET specific user 
app.get('/users/:firstName/:lastName', (req, res) => {
    const first = req.params.firstName
    const last = req.params.lastName
    mongodb.connect(port, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { firstName: first, lastName: last }
        dbo.collection('Users').find(query).toArray(function(error, result) { 
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

app.put('/users/:id/:date/:newDate', (req, res) => {
    mongodb.connect(port, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { date: req.params.date }
        var newQuery = { $set: { date: req.params.newDate } }
        dbo.collection('Users').updateOne(query, newQuery, function(error, result) { 
            if (error) throw error
            console.log(result)
            db.close()
        })
    })
})

app.post('/users/:id/:firstName/:lastName/:username/:password/:date', (req, res) => {
    const user = {
        id: req.body.id,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        username: req.body.username,
        password: req.body.password,
        date: req.body.date
    };

    mongodb.connect(url, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('Users').insertOne(user, function(error, result) {
            if (error) throw error;
            assert.equal(null, error)
            console.log('Item inserted')
            db.close();
        })
    })
})

const port = process.env.PORT || 1000
app.listen(port, () => console.log('Listening on ' + port + '...'))