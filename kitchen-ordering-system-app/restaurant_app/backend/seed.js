const mongoose = require('mongoose');
const MenuItem = require('./models/MenuItem');
const Table = require('./models/Table');
const Staff = require('./models/Staff');
const connectDB = require('./config/db');

async function seed() {
  await connectDB();

  // Menü ürünleri
  const menuItems = [
    {
      name: 'Classic Cheeseburger',
      description: 'Juicy beef patty with cheddar cheese, lettuce, tomato, and our special sauce',
      price: 12.99,
      category: 'Ana Yemek',
      imageUrl: '',
    },
    {
      name: 'Margherita Pizza',
      description: 'Traditional pizza with tomato sauce, mozzarella, and fresh basil',
      price: 14.99,
      category: 'Ana Yemek',
      imageUrl: '',
    },
    {
      name: 'Caesar Salad',
      description: 'Crisp romaine lettuce with Caesar dressing, croutons, and parmesan',
      price: 9.99,
      category: 'Salata',
      imageUrl: '',
    },
    {
      name: 'French Fries',
      description: 'Crispy golden fries with our seasoning blend',
      price: 4.99,
      category: 'Aperatif',
      imageUrl: '',
    },
    {
      name: 'Chocolate Brownie',
      description: 'Warm chocolate brownie served with vanilla ice cream',
      price: 7.99,
      category: 'Tatlı',
      imageUrl: '',
    },
    {
      name: 'Soda',
      description: 'Choice of Coke, Sprite, or Fanta',
      price: 2.99,
      category: 'İçecek',
      imageUrl: '',
    },
    {
      name: 'Chicken Wings',
      description: '8 pieces of spicy chicken wings with blue cheese dip',
      price: 11.99,
      category: 'Aperatif',
      imageUrl: '',
    },
    {
      name: 'Spaghetti Carbonara',
      description: 'Classic pasta with creamy sauce, bacon, and parmesan',
      price: 13.99,
      category: 'Ana Yemek',
      imageUrl: '',
    },
  ];

  // Masalar
  const tables = [
    { name: 'Table 1', capacity: 2, x: 0, y: 0, status: 'available' },
    { name: 'Table 2', capacity: 4, x: 1, y: 0, status: 'available' },
    { name: 'Table 3', capacity: 4, x: 2, y: 0, status: 'available' },
    { name: 'Table 4', capacity: 6, x: 0, y: 1, status: 'available' },
    { name: 'Table 5', capacity: 8, x: 1, y: 1, status: 'available' },
    { name: 'Table 6', capacity: 2, x: 2, y: 1, status: 'available' },
    { name: 'Table 7', capacity: 4, x: 0, y: 2, status: 'available' },
    { name: 'Table 8', capacity: 4, x: 1, y: 2, status: 'available' },
    { name: 'Table 9', capacity: 2, x: 2, y: 2, status: 'available' },
  ];

  // Personel
  const staff = [
    { name: 'John Smith', role: 'waiter' },
    { name: 'Alice Johnson', role: 'waiter' },
    { name: 'Mike Wilson', role: 'chef' },
    { name: 'Sarah Davis', role: 'manager' },
    { name: 'Emily Brown', role: 'waiter' },
    { name: 'David Lee', role: 'waiter' },
    { name: 'Linda Green', role: 'cashier' },
    { name: 'Robert King', role: 'chef' },
  ];

  try {
    await MenuItem.deleteMany();
    await Table.deleteMany();
    await Staff.deleteMany();
    await MenuItem.insertMany(menuItems);
    await Table.insertMany(tables);
    await Staff.insertMany(staff);
    console.log('Veritabanı başarıyla dolduruldu!');
  } catch (e) {
    console.error('Seed hatası:', e);
  } finally {
    mongoose.connection.close();
  }
}

seed(); 