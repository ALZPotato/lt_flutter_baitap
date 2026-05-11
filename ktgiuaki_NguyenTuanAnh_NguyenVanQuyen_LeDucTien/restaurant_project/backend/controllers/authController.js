const User = require('../models/User');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// ĐĂNG KÝ (SignUp) - Đẩy dữ liệu lên Atlas
exports.register = async (req, res) => {
    try {
        const { fullName, email, password } = req.body;

        // 1. Kiểm tra email đã tồn tại chưa
        let user = await User.findOne({ email });
        if (user) return res.status(400).json({ msg: "Email này đã được đăng ký!" });

        // 2. Tạo user mới (Mật khẩu tự mã hóa nhờ middleware ở Model User)
        user = new User({ fullName, email, password });
        await user.save();

        res.status(201).json({ msg: "Đăng ký tài khoản thành công!" });
    } catch (err) {
        console.error(err.message);
        res.status(500).send("Lỗi server khi đăng ký");
    }
};

// ĐĂNG NHẬP (SignIn)
exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // 1. Tìm user theo email
        const user = await User.findOne({ email });
        if (!user) return res.status(400).json({ msg: "Email không tồn tại!" });

        // 2. Kiểm tra mật khẩu
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ msg: "Mật khẩu không chính xác!" });

        // 3. Tạo Token JWT
        const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });

        res.json({
            token,
            user: { id: user._id, fullName: user.fullName, email: user.email }
        });
    } catch (err) {
        res.status(500).send("Lỗi server khi đăng nhập");
    }
};