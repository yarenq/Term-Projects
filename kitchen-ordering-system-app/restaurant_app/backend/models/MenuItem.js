const mongoose = require('mongoose');

const menuItemSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    description: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true,
        min: 0
    },
    category: {
        type: String,
        required: true,
        enum: ['Ana Yemek', 'Çorba', 'Salata', 'Tatlı', 'İçecek', 'Aperatif']
    },
    imageUrl: {
        type: String,
        default: 'default_food.png'
    },
    isAvailable: {
        type: Boolean,
        default: true
    },
    stock: {
        type: Number,
        default: 0,
        min: 0
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('MenuItem', menuItemSchema); 