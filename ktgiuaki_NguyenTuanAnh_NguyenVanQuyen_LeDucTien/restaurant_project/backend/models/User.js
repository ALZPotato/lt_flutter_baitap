const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const UserSchema = new mongoose.Schema({
    fullName: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true }
});

// SỬA TẠI ĐÂY: Dùng async function và bỏ tham số 'next'
UserSchema.pre('save', async function() {
    // Nếu mật khẩu không bị thay đổi thì thoát ra (không cần next)
    if (!this.isModified('password')) return;

    try {
        const salt = await bcrypt.genSalt(10);
        this.password = await bcrypt.hash(this.password, salt);
    } catch (err) {
        throw err; // Ném lỗi để Mongoose tự xử lý
    }
});

module.exports = mongoose.model('User', UserSchema);