const mongoose = require('mongoose');

const staffSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    role: {
        type: String,
        enum: ['waiter', 'chef', 'manager', 'cashier'],
        required: true
    },
    isActive: {
        type: Boolean,
        default: true
    },
    currentShift: {
        start: Date,
        end: Date
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Staff', staffSchema); 