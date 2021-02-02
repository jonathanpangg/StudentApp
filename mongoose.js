/*
var mongoose = require('mongoose')

const url = process.env.mongodb_URI || 'mongodb+srv://StudentUsers:Jonathan3388@cluster0.xbzay.mongodb.net/StudentApp?retryWrites=true&w=majority'
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
*/