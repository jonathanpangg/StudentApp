const mongoose = require('mongoose')
const Schema = mongoose.Schema

const gymSchema = new Schema ({
    id: {
        type: String,
        require: true 
    },
    activity: {
        type: [String],
        require: true,
    },
    completion: {
        type: [Boolean],
        require: true
    }
})

const Gym = mongoose.model('Users', gymSchema)
module.exports = Gym