const MenuItem = require('../models/MenuItem');

// Tüm menü öğelerini getir
const getAllMenuItems = async (req, res) => {
    try {
        const menuItems = await MenuItem.find();
        res.json(menuItems);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Yeni menü öğesi ekle
const createMenuItem = async (req, res) => {
    try {
        const menuItem = new MenuItem(req.body);
        const newMenuItem = await menuItem.save();
        res.status(201).json(newMenuItem);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Menü öğesini güncelle
const updateMenuItem = async (req, res) => {
    try {
        const menuItem = await MenuItem.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );
        if (!menuItem) {
            return res.status(404).json({ message: 'Menü öğesi bulunamadı' });
        }
        res.json(menuItem);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Menü öğesini sil
const deleteMenuItem = async (req, res) => {
    try {
        const menuItem = await MenuItem.findByIdAndDelete(req.params.id);
        if (!menuItem) {
            return res.status(404).json({ message: 'Menü öğesi bulunamadı' });
        }
        res.json({ message: 'Menü öğesi silindi' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getAllMenuItems,
    createMenuItem,
    updateMenuItem,
    deleteMenuItem
}; 