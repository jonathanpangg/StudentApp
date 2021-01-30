var express = require('express')
var app = express()
const Users = require('./user/user')

app.use(express.json())

var users = [
    {
        firstName: 'Timmy',
        lastName: 'Wong',
        email: 'TimmyWong@gmail.com',
        password: 'Timmy123'
    }
]
app.get('/users', (req, res) => {
    const addUser = new Users({ 
        firstName: 'test',
        lastName: 'test',
        email: 'test',
        password: 'test'
    })
    .save(result) 
    res.json(result);
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
})

const port = process.env.PORT || 1000
app.listen(port, () => console.log('Listening on ' + port + '...'))