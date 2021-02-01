var mongoose = require('mongoose')

const url = 'https://heroku-studentapp.herokuapp.com'
mongoose.connect(url, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useCreateIndex: true
})

const db = mongoose.connection

db.on('error', () => {
  console.log('mongodb error!')
})

db.on('open', () => {
  console.log('mongodb connected!')
})

module.exports = db