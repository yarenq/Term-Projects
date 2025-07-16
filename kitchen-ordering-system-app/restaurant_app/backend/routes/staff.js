const express = require('express');
const router = express.Router();
const Staff = require('../models/Staff');

// Tüm personeli getir
router.get('/', async (req, res) => {
    try {
        const staff = await Staff.find();
        res.json(staff);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Yeni personel ekle
router.post('/', async (req, res) => {
    const staff = new Staff(req.body);
    try {
        const newStaff = await staff.save();
        res.status(201).json(newStaff);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Personel vardiyasını güncelle
router.patch('/:id/shift', async (req, res) => {
    try {
        const staff = await Staff.findByIdAndUpdate(
            req.params.id,
            { currentShift: req.body },
            { new: true }
        );
        res.json(staff);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// Personel durumunu güncelle (aktif/pasif)
router.patch('/:id/status', async (req, res) => {
    try {
        const staff = await Staff.findByIdAndUpdate(
            req.params.id,
            { isActive: req.body.isActive },
            { new: true }
        );
        res.json(staff);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

module.exports = router; 