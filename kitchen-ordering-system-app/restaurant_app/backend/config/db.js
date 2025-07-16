const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        const conn = await mongoose.connect('mongodb://localhost:27017/restaurant_db', {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log(`MongoDB Bağlantısı Başarılı: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Hata: ${error.message}`);
        process.exit(1);
    }
};

module.exports = connectDB; 