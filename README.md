<div align="center">

<img src="assets/icon/app_icon.png" width="128" height="128" alt="Self Focus Pixel Icon" />

# 🐾 Self Focus Pixel
### *Retro 8-Bit Pomodoro Focus Timer & Virtual Pixel Pet Streaks*
*Xây dựng tính kỷ luật, nuôi lớn thú cưng ảo và giữ vững ngọn lửa thói quen mỗi ngày*

[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/maico-le/self-manegement-mb/releases)
[![Version](https://img.shields.io/badge/Version-v1.0.0-FA520F?style=for-the-badge)](https://github.com/maico-le/self-manegement-mb/releases/latest)
[![Style](https://img.shields.io/badge/Style-Mistral_Pixel_8--Bit-FFAF00?style=for-the-badge)](#)
[![No Ads](https://img.shields.io/badge/Ads-100%25_Free-brightgreen?style=for-the-badge)](#)

<br/>

### 📲 [👉 TẢI NGAY BẢN CÀI ĐẶT APK CHO ANDROID (TRỰC TIẾP) 👈](https://github.com/maico-le/self-manegement-mb/releases/latest/download/app-release.apk)
*Hoặc xem các bản cập nhật và changelog tại trang [GitHub Releases](https://github.com/maico-le/self-manegement-mb/releases).*

---

</div>

## 🌟 Giới Thiệu

**Self Focus Pixel** là ứng dụng tự quản lý bản thân trên di động (Android / iOS) kết hợp giữa phương pháp tập trung **Pomodoro**, cơ chế nuôi **thú ảo Tamagotchi** hoài niệm và hệ thống **chuỗi thói quen (Streaks)** dành cho việc rèn luyện thể thao và học ngoại ngữ.

Toàn bộ ứng dụng được thiết kế theo phong cách đồ họa **Mistral Retro 8-bit** độc đáo: màu cam Mistral (`#FA520F`), vàng ánh kim (`#FFAF00`), đường viền đen góc cạnh 2px, hiệu ứng đổ bóng phẳng không nhòe `3px 3px 0px #000000`, phông chữ Monospace cùng toàn bộ icon được vẽ bằng mã nguồn thuần qua `CustomPainter`.

---

## 🎮 Tính Năng Cốt Lõi

### 1. ⏱️ Pomodoro Focus Timer & Thú Cưng Pixie
* **Chạy phiên tập trung**: Mặc định 25 phút tập trung cao độ, 5 phút nghỉ ngắn, 15 phút nghỉ dài (có thể tùy chỉnh).
* **Nuôi thú ảo 8-bit (Pixie)**:
  * 🐣 **Hoàn thành phiên**: Thú cưng nhận thêm EXP, nhảy múa vui mừng và từng bước tiến hóa qua 5 cấp độ:
    1. **Trứng huyền bí (Egg)**
    2. **Thú con tinh nghịch (Baby)**
    3. **Thiếu niên năng động (Teen)**
    4. **Trưởng thành uy dũng (Adult)**
    5. **Thần thú thần thoại (Mythic)**
  * 😭 **Bỏ cuộc giữa chừng (Give up)**: Thú cưng sẽ bật khóc ròng, buồn bã và mất đi năng lượng rèn luyện, nhắc nhở bạn giữ kỷ luật.

---

### 2. 🏋️ Chế Độ Tập Thể Dục & Báo Thức Plank (Workout Mode)
* **Tạo bài tập linh hoạt theo ý muốn**:
  * **Kiểu Số lần (Reps)**: Cài đặt mục tiêu Reps x Hiệp (ví dụ: *Hít đất 15 cái x 3 hiệp*, *Squat 20 cái x 4 hiệp*).
  * **Kiểu Thời gian đếm ngược (Duration)**: Dành cho các bài tập giữ sức như **Plank bụng (60s)**, Giãn cơ (45s)...
* **Báo thức Local Notification khi hết giờ**: Khi đồng hồ đếm ngược kết thúc, ứng dụng tự động rung chuông và bắn thông báo báo thức âm lượng lớn để bạn nghỉ ngơi đúng lúc.

---

### 3. 🇬🇧 🇯🇵 Chuỗi Rèn Luyện Ngoại Ngữ & Báo Thức Theo Lịch (Study Streaks)
* **Kỹ năng chuyên biệt**:
  * 🏋️ **Tập thể dục / Gym** (Icon Quả tạ pixel)
  * 🇬🇧 **Học English** (Icon Sách & Ký tự A-Z pixel)
  * 🇯🇵 **Học Japanese** (Icon Cổng Torii & Kanji pixel)
  * 🎯 **Mục tiêu kỹ năng tùy chọn**
* **Đặt lịch học & Tần suất thông báo**:
  * Chọn chính xác **Giờ học** (`TimeOfDay`, ví dụ: `19:30`, `20:00`, `21:15`).
  * Chọn **Tần suất lặp lại**: *Hàng ngày (7 ngày)*, *T2 - T6 (Ngày thường)*, *T7 - CN (Cuối tuần)* hoặc chọn các ngày cụ thể bất kỳ.
  * **Báo thức tự động**: Lên lịch chính xác từng ngày trong tuần qua `flutter_local_notifications` kết hợp `timezone` để nhắc nhở bạn duy trì ngọn lửa streak không bị tắt.
  * Nút **THỬ CHUÔNG 🔔** trên từng thẻ để kiểm tra ngay âm thanh và biểu ngữ thông báo.

---

## 🎨 Phong Cách Đồ Họa (Mistral Pixel Design)

| Thành Phần | Quy Chuẩn Thiết Kế |
| :--- | :--- |
| **Màu chủ đạo** | `#FA520F` (Cam lửa Mistral), `#FFAF00` (Vàng kim), `#16A34A` (Xanh thành công), `#0F172A` (Đêm tối) |
| **Đường viền** | `2.0px solid #000000`, góc vuông tuyệt đối (`BorderRadius.zero`) |
| **Đổ bóng (Shadow)** | Đổ bóng phẳng đặc `3px 3px 0px #000000`, không làm mờ |
| **Pixel Icons** | Vẽ hoàn toàn bằng tọa độ hình chữ nhật qua `CustomPainter` (Ngọn lửa, Quả tạ, Cổng Torii, Sách Anh ngữ, Trái tim) |
| **Typography** | Font đơn cách hoài niệm (`fontFamily: 'monospace'`) |

---

## 📦 Tải Bản Cài Đặt APK

Bạn có thể tải trực tiếp file cài đặt APK được build tự động qua GitHub Actions:
👉 **[Tải file `app-release.apk` tại mục Releases](https://github.com/maico-le/self-manegement-mb/releases)**

---

## 🛠️ Hướng Dẫn Cài Đặt & Phát Triển Cục Bộ

### 1. Yêu cầu hệ thống
* Flutter SDK: `>= 3.13.0`
* Dart SDK: `>= 3.1.0`
* Java JDK: `17` (hỗ trợ Core Library Desugaring cho Android)

### 2. Cài đặt mã nguồn
```bash
# Clone repository
git clone https://github.com/maico-le/self-manegement-mb.git
cd self-manegement-mb

# Cài đặt thư viện dependencies
flutter pub get

# Kiểm tra phân tích cú pháp tĩnh
flutter analyze

# Chạy bộ kiểm thử tự động
flutter test
```

### 3. Build file APK phát hành
```bash
flutter build apk --release
```
*File APK đầu ra nằm tại:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 📥 Hướng Dẫn Cài Đặt Nhanh (Android)
1. Nhấn tải file cài đặt: [**app-release.apk (Bản mới nhất)**](https://github.com/maico-le/self-manegement-mb/releases/latest/download/app-release.apk).
2. Sau khi tải xong, nhấn mở file `.apk` và chọn **Cài đặt**.
   *(Nếu hệ điều hành Android hỏi quyền, bật **Cho phép từ nguồn này** cho trình duyệt của bạn)*.
3. Mở ứng dụng **Self Focus Pixel** và bắt đầu phiên tập trung Pomodoro đầu tiên!

---

## 📄 Bản Quyền

Dự án được phân phối dưới giấy phép [MIT License](LICENSE).
Mọi đóng góp và ý kiến đóng góp tính năng luôn được hoan nghênh!
