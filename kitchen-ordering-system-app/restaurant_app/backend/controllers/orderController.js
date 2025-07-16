const Order = require('../models/Order');
const Table = require('../models/Table');
const MenuItem = require('../models/MenuItem');

// Tüm siparişleri getir
const getAllOrders = async (req, res) => {
    try {
        const orders = await Order.find()
            .populate('tableId')
            .populate('items.menuItem');
        res.json(orders);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Yeni sipariş oluştur
const createOrder = async (req, res) => {
    try {
        if (!req.body.tableId) {
            return res.status(400).json({ message: 'Masa ID\'si gerekli' });
        }
        if (!req.body.items || !Array.isArray(req.body.items) || req.body.items.length === 0) {
            return res.status(400).json({ message: 'Sipariş kalemleri gerekli' });
        }
        if (typeof req.body.totalAmount !== 'number' || req.body.totalAmount <= 0) {
            return res.status(400).json({ message: 'Geçerli bir toplam tutar gerekli' });
        }

        for (const item of req.body.items) {
            const menuItem = await MenuItem.findById(item.menuItem);
            item.price = menuItem ? menuItem.price : 0;
        }

        const order = new Order(req.body);
        const newOrder = await order.save();
        
        const populatedOrder = await Order.findById(newOrder._id)
            .populate('tableId')
            .populate('items.menuItem');
        
        res.status(201).json(populatedOrder);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Sipariş durumunu güncelle
const updateOrderStatus = async (req, res) => {
    try {
        const order = await Order.findById(req.params.id);
        if (!order) {
            return res.status(404).json({ message: 'Sipariş bulunamadı' });
        }
        
        const itemIndex = order.items.findIndex(item => item._id.toString() === req.body.itemId);
        if (itemIndex === -1) {
            return res.status(404).json({ message: 'Sipariş kalemi bulunamadı' });
        }

        order.items[itemIndex].status = req.body.status;
        const updatedOrder = await order.save();
        
        const populatedOrder = await Order.findById(updatedOrder._id)
            .populate('tableId')
            .populate('items.menuItem');
        res.json(populatedOrder);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Sipariş ödemesini güncelle
const updateOrderPayment = async (req, res) => {
    try {
        const order = await Order.findByIdAndUpdate(
            req.params.id,
            {
                isPaid: true,
                paymentMethod: req.body.paymentMethod
            },
            { new: true }
        ).populate('tableId').populate('items.menuItem');

        if (order && order.tableId) {
            await Table.findByIdAndUpdate(
                order.tableId._id,
                { 
                    status: 'available',
                    serverId: null  // Garson atamasını kaldır
                }
            );
        }
        
        res.json(order);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Mutfak siparişlerini getir
const getKitchenOrders = async (req, res) => {
    try {
        const orders = await Order.find({
            'items.status': { $in: ['pending', 'preparing'] }
        })
        .populate('tableId')
        .populate('items.menuItem')
        .sort({ createdAt: 1 });
        
        res.json(orders);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Raporlama işlemleri
const getSummaryReport = async (req, res) => {
    try {
        const totalOrders = await Order.countDocuments();
        const paidOrders = await Order.countDocuments({ isPaid: true });
        const pendingOrders = await Order.countDocuments({ isPaid: false });
        
        const revenueResult = await Order.aggregate([
            { $match: { isPaid: true } },
            { $group: { _id: null, total: { $sum: '$totalAmount' } } }
        ]);
        const totalRevenue = revenueResult.length > 0 ? revenueResult[0].total : 0;

        const popularItems = await Order.aggregate([
            { $unwind: '$items' },
            { $group: {
                _id: '$items.menuItem',
                totalQuantity: { $sum: '$items.quantity' },
                items: { $push: { price: '$items.price', quantity: '$items.quantity' } }
            }},
            { $sort: { totalQuantity: -1 } },
            { $limit: 5 },
            { $lookup: {
                from: 'menuitems',
                localField: '_id',
                foreignField: '_id',
                as: 'menuItemDetails'
            }},
            { $unwind: '$menuItemDetails' },
            { $project: {
                name: '$menuItemDetails.name',
                totalQuantity: 1,
                items: 1,
                menuItemPrice: '$menuItemDetails.price'
            }}
        ]);

        const popularItemsWithRevenue = popularItems.map(item => {
            const totalRevenue = item.items.reduce((sum, i) => {
                const price = (i.price && i.price > 0) ? i.price : item.menuItemPrice;
                return sum + price * i.quantity;
            }, 0);
            return {
                name: item.name,
                totalQuantity: item.totalQuantity,
                totalRevenue: totalRevenue
            };
        });

        res.json({
            totalOrders,
            paidOrders,
            pendingOrders,
            totalRevenue,
            popularItems: popularItemsWithRevenue
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getAllOrders,
    createOrder,
    updateOrderStatus,
    updateOrderPayment,
    getKitchenOrders,
    getSummaryReport
}; 