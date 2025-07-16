const Table = require('../models/Table');

// Tüm masaları getir
const getAllTables = async (req, res) => {
    try {
        const tables = await Table.find();
        res.json(tables);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Yeni masa ekle
const createTable = async (req, res) => {
    try {
        const table = new Table(req.body);
        const newTable = await table.save();
        res.status(201).json(newTable);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Masa durumunu güncelle
const updateTableStatus = async (req, res) => {
    try {
        const table = await Table.findByIdAndUpdate(
            req.params.id,
            { status: req.body.status },
            { new: true }
        );
        if (!table) {
            return res.status(404).json({ message: 'Masa bulunamadı' });
        }
        res.json(table);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

// Masayı sil
const deleteTable = async (req, res) => {
    try {
        const table = await Table.findByIdAndDelete(req.params.id);
        if (!table) {
            return res.status(404).json({ message: 'Masa bulunamadı' });
        }
        res.json({ message: 'Masa silindi' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// Garson ata
const assignServer = async (req, res) => {
    try {
        // serverId boş string, null veya undefined ise null olarak kaydet
        const serverId = (req.body.serverId === '' || req.body.serverId === null || req.body.serverId === undefined) 
            ? null 
            : req.body.serverId;
            
        const table = await Table.findByIdAndUpdate(
            req.params.id,
            { $set: { serverId: serverId } },  // $set operatörünü kullanarak kesin güncelleme yap
            { new: true, runValidators: true }  // runValidators ekleyerek şema validasyonunu çalıştır
        );
        
        if (!table) {
            return res.status(404).json({ message: 'Masa bulunamadı' });
        }
        
        console.log('Garson ataması güncellendi:', { tableId: req.params.id, serverId: serverId });  // Log ekle
        res.json(table);
    } catch (error) {
        console.error('Garson atama hatası:', error);  // Hata logla
        res.status(400).json({ message: error.message });
    }
};

module.exports = {
    getAllTables,
    createTable,
    updateTableStatus,
    deleteTable,
    assignServer
}; 