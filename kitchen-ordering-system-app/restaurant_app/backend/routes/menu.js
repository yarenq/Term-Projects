const express = require('express');
const router = express.Router();
const menuController = require('../controllers/menuController');

// Tüm menü öğelerini getir
router.get('/', menuController.getAllMenuItems);

// Yeni menü öğesi ekle
router.post('/', menuController.createMenuItem);

// Menü öğesini güncelle
router.put('/:id', menuController.updateMenuItem);

// Menü öğesini sil
router.delete('/:id', menuController.deleteMenuItem);

module.exports = router; 