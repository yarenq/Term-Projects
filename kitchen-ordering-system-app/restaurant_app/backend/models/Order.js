const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
    menuItem: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'MenuItem',
        required: true
    },
    quantity: {
        type: Number,
        required: true,
        min: 1
    },
    specialInstructions: String,
    status: {
        type: String,
        enum: ['pending', 'preparing', 'ready', 'served', 'cancelled'],
        default: 'pending'
    },
    price: {
        type: Number,
        default: 0
    }
});

const orderSchema = new mongoose.Schema({
    tableId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Table',
        required: true
    },
    items: [orderItemSchema],
    isPaid: {
        type: Boolean,
        default: false
    },
    paymentMethod: {
        type: String,
        enum: ['cash', 'credit_card', 'online'],
        required: false
    },
    totalAmount: {
        type: Number,
        required: true
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Order', orderSchema); 