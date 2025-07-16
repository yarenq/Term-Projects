const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const Table = require('../models/Table');
const Order = require('../models/Order');

// Tüm siparişleri getir
router.get('/', orderController.getAllOrders);

// Yeni sipariş oluştur
router.post('/', orderController.createOrder);

// Sipariş durumunu güncelle
router.patch('/:id/status', orderController.updateOrderStatus);

// Sipariş ödemesini güncelle
router.patch('/:id/payment', orderController.updateOrderPayment);

// Mutfak siparişlerini getir
router.get('/kitchen', orderController.getKitchenOrders);

// Raporlama endpoint'leri
router.get('/reports/summary', orderController.getSummaryReport);

// Günlük rapor
router.get('/reports/daily', async (req, res) => {
    try {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        const tomorrow = new Date(today);
        tomorrow.setDate(tomorrow.getDate() + 1);

        // Günlük sipariş sayısı
        const dailyOrders = await Order.countDocuments({
            createdAt: { $gte: today, $lt: tomorrow }
        });

        // Günlük gelir
        const dailyRevenueResult = await Order.aggregate([
            {
                $match: {
                    isPaid: true,
                    createdAt: { $gte: today, $lt: tomorrow }
                }
            },
            {
                $group: {
                    _id: null,
                    total: { $sum: '$totalAmount' }
                }
            }
        ]);
        const dailyRevenue = dailyRevenueResult.length > 0 ? dailyRevenueResult[0].total : 0;

        // Günlük ödeme yöntemleri dağılımı
        const paymentMethods = await Order.aggregate([
            {
                $match: {
                    isPaid: true,
                    createdAt: { $gte: today, $lt: tomorrow }
                }
            },
            {
                $group: {
                    _id: '$paymentMethod',
                    count: { $sum: 1 },
                    total: { $sum: '$totalAmount' }
                }
            }
        ]);

        res.json({
            dailyOrders,
            dailyRevenue,
            paymentMethods
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Tüm siparişleri sil (sadece test için!)
router.delete('/all', async (req, res) => {
    try {
        await Order.deleteMany();
        res.json({ message: 'Tüm siparişler silindi' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Sistemi sıfırla (tüm siparişleri sil, masaları sıfırla)
router.post('/reset-system', async (req, res) => {
    try {
        // Tüm siparişleri sil
        await Order.deleteMany({});
        
        // Tüm masaları available durumuna getir
        await Table.updateMany({}, { 
            status: 'available',
            serverId: null 
        });
        
        res.json({ 
            message: 'Sistem başarıyla sıfırlandı',
            details: {
                ordersDeleted: true,
                tablesReset: true
            }
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router; 