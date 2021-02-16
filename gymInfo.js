const mongoose = require('mongoose')
const Schema = mongoose.Schema

const gymSchema = new Schema ({
    id: {
        type: String,
        require: true 
    },
    data: {
        date: {
            type: [String],
            require: true
        },
        activity: {
            type: [String],
            require: true
        },
        completion: {
            type: [Boolean],
            require: true
        }
    }
})

const GymInfo = mongoose.model('GymInfo', gymSchema)
module.exports = GymInfo