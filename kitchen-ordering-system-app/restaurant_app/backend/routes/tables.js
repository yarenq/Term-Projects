const express = require('express');
const router = express.Router();
const tableController = require('../controllers/tableController');

// Tüm masaları getir
router.get('/', tableController.getAllTables);

// Yeni masa ekle
router.post('/', tableController.createTable);

// Masa durumunu güncelle
router.patch('/:id/status', tableController.updateTableStatus);

// Garson ata
router.patch('/:id/assign', tableController.assignServer);

// Masayı sil
router.delete('/:id', tableController.deleteTable);

module.exports = router; 