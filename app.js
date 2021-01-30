var express = require('express')
var app = express()
var mongodb = require('mongodb')
var assert = require('assert')
var db = require('./mongoose')
const url = process.env.mongodb_URI || 'mongodb+srv://StudentUsers:Jonathan3388@cluster0.xbzay.mongodb.net/StudentApp?retryWrites=true&w=majority'
var users = []
app.use(express.json())

app.get('/users', (req, res) => {
    mongodb.connect(url, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('Users').find({}).toArray(function(err, result) {
            if (error) throw error
            res.send(result)
            console.log(result.id)
            db.close()
        })
    })
})

// /GET specific user 
app.get('/users/id', (req, res) => {
    mongodb.connect(url, function(error, db) {
        if (error) throw error
        dbo = db.db('StudentApp')
        var query = { firstName: 'Jonathan' }
        dbo.collection('Users').find(query).toArray(function(error, result) {
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

app.post('/users/:firstName/:lastName/:email/:password', (req, res) => {
    const user = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        password: req.body.password
    };
    users.push(user)
    res.send(users)

    mongodb.connect(url, function (error, data) {
        assert.equal(null, error)
        db.collection('Users').insertOne(user, function(error, result) {
            assert.equal(null, error)
            console.log('Item inserted')
            db.close();
        })
    })
})

const port = process.env.PORT || 1000
app.listen(port, () => console.log('Listening on ' + port + '...'))