const Food = require('../models/Food');

exports.getAllFoods = async (req, res) => {
    try {
        const foods = await Food.find();
        res.json(foods);
    } catch (err) {
        res.status(500).json({ msg: "Lỗi lấy dữ liệu" });
    }
};