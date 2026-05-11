const mongoose = require('mongoose');
const Food = require('./models/Food');
require('dotenv').config();

const sampleFoods = [
    { name: "Noodles", price: 100, category: "Chinese", image: "https://cdn-icons-png.flaticon.com/512/1471/1471262.png" },
    { name: "Fajita Chicken Burrito", price: 825, category: "Mexican", image: "https://cdn-icons-png.flaticon.com/512/590/590810.png" },
    { name: "Gulab Jamun", price: 126, category: "South Indian", image: "https://cdn-icons-png.flaticon.com/512/2235/2235016.png" },
    { name: "Beverages Drink", price: 50, category: "Beverages", image: "https://cdn-icons-png.flaticon.com/512/3121/3121784.png" }
];

const seedDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        await Food.deleteMany({}); // Xóa dữ liệu cũ nếu có
        await Food.insertMany(sampleFoods);
        console.log("✅ Đã nạp dữ liệu món ăn mẫu thành công!");
        process.exit();
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

seedDB();