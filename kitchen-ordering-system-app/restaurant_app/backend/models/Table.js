const mongoose = require('mongoose');

const tableSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    capacity: {
        type: Number,
        required: true,
        min: 1
    },
    x: {
        type: Number,
        required: true
    },
    y: {
        type: Number,
        required: true
    },
    status: {
        type: String,
        enum: ['available', 'occupied', 'reserved', 'outOfService'],
        default: 'available'
    },
    serverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Staff'
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Table', tableSchema); 