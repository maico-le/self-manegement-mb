# 🐾 Self Focus Pixel (Retro Pomodoro & Pet Streaks)

> Một ứng dụng tự quản lý bản thân, rèn luyện thói quen và tập trung cao độ kết hợp nuôi thú ảo Pixel phong cách Mistral Retro 8-bit.

[![Build & Release APK](https://github.com/maico-le/self-manegement-mb/actions/workflows/build_release.yml/badge.svg)](https://github.com/maico-le/self-manegement-mb/actions/workflows/build_release.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🌟 Ý Tưởng Cốt Lõi

Ứng dụng giải quyết sự trì hoãn và thiếu động lực khi học tập và rèn luyện thể thao hàng ngày:
* **Focus Timer (Pomodoro)**: Chạy phiên tập trung (mặc định 25 phút, nghỉ 5 phút) để hoàn thành các mục tiêu cụ thể.
* **Thú Ảo Pixel (Pixie)**: 
  * 🐣 **Hoàn thành phiên tập trung**: Thú cưng nhận thêm EXP, nhảy múa vui vẻ, tăng cấp và tiến hóa qua 5 giai đoạn (Trứng -> Thú con -> Thiếu niên -> Trưởng thành -> Thần thú).
  * 😭 **Bỏ cuộc giữa chừng (Give up)**: Thú cưng sẽ buồn bã, khóc ròng, nhắc nhở bạn giữ kỷ luật bản thân.
* **Chuỗi Rèn Luyện (Daily Streaks)**:
  * 🏋️ **Tập thể dục**: Icon quả tạ pixel đặc trưng, theo dõi số ngày tập gym / cardio liên tục.
  * 🇬🇧 **Học English**: Icon sách / chữ A-Z pixel, luyện từ vựng, nghe nói.
  * 🇯🇵 **Học Japanese**: Icon cổng Torii / chữ Kanji pixel, luyện Kanji, ngữ pháp JLPT.
  * 🔥 **Ngọn lửa Streak**: Đếm số ngày liên tục không bị đứt đoạn, bảng chấm 7 ngày trong tuần sáng đèn khi hoàn thành.
* **Local Notifications**:
  * Chuông báo kết thúc phiên tập trung và giờ nghỉ.
  * Nhắc nhở lúc 20:00 tối mỗi ngày để không làm tắt ngọn lửa streak.

---

## 🎨 Phong Cách Thiết Kế (Mistral Retro Pixel)

* **Bảng màu**: Màu cam Mistral (`#FA520F`), vàng hổ phách (`#FFAF00`), xanh lá thành công (`#16A34A`), đỏ cảnh báo (`#EF4444`).
* **Đường nét**: Viền đen góc cạnh `2.0px`, đổ bóng phẳng đặc `3px 3px 0px #000000`, không bo cong góc (`borderRadius: BorderRadius.zero`).
* **Icon & Thú cưng**: Được vẽ trực tiếp bằng `CustomPainter` các khối pixel sắc nét, đảm bảo nhẹ, mượt và không bị phụ thuộc vào hình ảnh ngoại tuyến.
* **Phông chữ**: Monospace retro terminal hoài niệm.

---

## 🚀 Cài Đặt & Chạy Cục Bộ

```bash
# 1. Clone repository
git clone https://github.com/maico-le/self-manegement-mb.git
cd self-manegement-mb

# 2. Cài đặt dependencies
flutter pub get

# 3. Phân tích & Kiểm thử
flutter analyze
flutter test

# 4. Chạy trên điện thoại hoặc giả lập
flutter run
```

---

## 📦 Tải Bản Cài Đặt APK

Tải trực tiếp bản APK mới nhất tại tab [**Releases**](https://github.com/maico-le/self-manegement-mb/releases).
