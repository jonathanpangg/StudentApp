const { Int32 } = require('mongodb')
const mongoose = require('mongoose')
const Schema = mongoose.Schema

const restaurantsSchema = new Schema ({
    restaurantID: {
        type: Int32,
        required: false
    },
    restaurantName: {
        type: String,
        required: false
    },
    countryCode: {
        type: Int32,
        required: false
    },
    city: {
        type: String,
        required: false
    },
    address: {
        type: String,
        required: false
    },
    locality: {
        type: String,
        required: false
    },
    localityVerbose: {
        type: String,
        required: false
    },
    longitude: {
        type: Double,
        required: false
    },
    latitude: {
        type: Double,
        required: false
    },
    cuisines: {
        type: String,
        required: false
    },
    averageCostForTwo: {
        type: Int32,
        required: false
    },
    currency: {
        type: String,
        required: false
    },
    hasTableBooking: {
        type: String,
        required: false
    },
    hasOnlineDelivery: {
        type: String,
        required: false
    },
    isDeliveringNow: {
        type: String,
        required: false
    },
    switchToOrderMenu: {
        type: String,
        required: false
    },
    priceRange: {
        type: Int32,
        required: false
    },
    aggregateRating: {
        type: Double,
        required: false
    },
    ratingColor: {
        type: String,
        required: false
    },
    ratingText: {
        type: String,
        required: false
    },
    votes: {
        type: Int32,
        required: false
    }
})

const Restaurants = mongoose.model('Restaurants', restaurantsSchema)
module.exports = Restaurants