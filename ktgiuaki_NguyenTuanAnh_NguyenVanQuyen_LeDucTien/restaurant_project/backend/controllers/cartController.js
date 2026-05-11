const Cart = require('../models/Cart');

// Lấy giỏ hàng của user
exports.getCart = async (req, res) => {
    try {
        let cart = await Cart.findOne({ userId: req.params.userId }).populate('items.foodId');
        if (!cart) {
            cart = new Cart({ userId: req.params.userId, items: [] });
            await cart.save();
        }
        res.json(cart);
    } catch (err) {
        res.status(500).json({ msg: "Lỗi lấy giỏ hàng" });
    }
};

// Cập nhật giỏ hàng (Thêm/Sửa/Xóa)
exports.updateCart = async (req, res) => {
    const { userId, items } = req.body; // items là mảng {foodId, quantity}
    try {
        let cart = await Cart.findOneAndUpdate(
            { userId: userId },
            { items: items },
            { new: true, upsert: true }
        );
        res.json(cart);
    } catch (err) {
        res.status(500).json({ msg: "Lỗi lưu giỏ hàng" });
    }
};