var express = require('express')
var app = express()
var mongodb = require('mongodb')
var assert = require('assert')
var db = require('./mongoose')  
const mongodb_URI = process.env.mongodb_URI || 'mongodb+srv://StudentUsers:Jonathan3388@cluster0.xbzay.mongodb.net/StudentApp?retryWrites=true&w=majority'
var users = []
app.use(express.json())

// /GET all users
app.get('/users/Jonathan338833&&', (req, res) => {
    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('Users').find({}).toArray(function(err, result) {
            if (error) throw error
            res.send(result)
            db.close()
        })
    })
})

// /GET specific user 
app.get('/users/:username/:password', (req, res) => {
    const user = req.params.username
    const pass = req.params.password
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { username: user, password: pass }
        dbo.collection('Users').find(query).toArray(function(error, result) { 
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

// /POST new user
app.post('/users/:id/:firstName/:lastName/:username/:password/:date', (req, res) => {
    const user = {
        id: req.body.id,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        username: req.body.username,
        password: req.body.password,
        date: req.body.date
    };

    mongodb.connect(mongodb_URI, function (error, db) {
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

// /GET gym info
app.get('/gym/:id', (req, res) => {
    const ID = req.params.id
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { id: ID }
        dbo.collection('GymInfo').find(query).toArray(function(error, result) { 
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

// /PUT specific user 
app.put('/users/:id/:newDate', (req, res) => {
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { id: req.params.id }
        var newQuery = { $set: { date: req.params.newDate } }
        dbo.collection('Users').updateOne(query, newQuery, function(error, result) { 
            if (error) throw error
            console.log(result)
            db.close()
        })
    })
})

// /POST gym info
app.post('/gym/:id/:activity/:completion', (req, res) => {
    const gym = {
        id: req.body.id,
        activity: req.body.activity,
        completion: req.body.completion
    };

    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('GymInfo').insertOne(gym, function(error, result) {
            if (error) throw error;
            assert.equal(null, error)
            console.log('Item inserted')
            db.close();
        })
    })
})

// /PUT gym info
app.put('/gym/:id/:newActivity/:newCompletion', (req, res) => {
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('StudentApp')
        var query = { id: req.params.id }
        var newQuery = { $set: { "id": req.params.id, "activity":req.params.newActivity, "completion":req.params.newCompletion } }
        dbo.collection('GymInfo').updateOne(query, newQuery, function(error, result) { 
            if (error) throw error
            console.log(result)
            db.close()
        })
    })
})

const port = process.env.PORT || 2000
app.listen(port, () => console.log('Listening on ' + port + '...'))