# StealHex VN

[![iOS Sideload Build & Release](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/actions/workflows/ios-build.yml/badge.svg)](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/actions/workflows/ios-build.yml)
[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Language](https://img.shields.io/badge/Language-VI%20%7C%20EN-blue.svg)](#)
[![Author](https://img.shields.io/badge/Author-VanKhoa-orange.svg)](https://github.com/emlavankhoahienma-hue)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Ứng dụng tạo hình ảnh nghệ thuật AI native với phong cách thiết kế tối giản, thanh lịch theo tiêu chuẩn Human Interface Guidelines của Apple. Tích hợp thuật toán phân tích ngữ nghĩa tự động định tuyến câu lệnh (Prompt) đến 5 mô hình AI chuyên biệt từ Hugging Face (FLUX.1 Schnell, FLUX Realism, FLUX Anime, FLUX 3D Render, SDXL Turbo). Hỗ trợ song ngữ Tiếng Việt (VI) và English (EN).

A minimalist, native SwiftUI AI image generation application. Features an intelligent semantic prompt classifier that automatically analyzes prompt intent and routes requests to 5 specialized open AI engines (FLUX.1 Schnell, FLUX Realism, FLUX Anime, FLUX 3D Render, SDXL Turbo). Full bilingual support (VI / EN).

---

## Tính năng chính / Key Features

- **Bộ nâng cấp ngữ nghĩa câu lệnh (On-Device Semantic PromptEngine)**: Tự động phân tích, dịch thuật và mở rộng các từ khóa tiếng Việt sang tiếng Anh chuyên sâu về nhiếp ảnh và nghệ thuật (ống kính 85mm, ánh sáng điện ảnh, độ phân giải 8K, chất cảm bề mặt da, v.v.) giúp mô hình AI hiểu sâu và tạo ra bức tranh chính xác, sống động.
- **Hỗ trợ Máy chủ cá nhân / Local PC GPU (Automatic1111 / ComfyUI / Forge / ngrok)**: Cho phép kết nối trực tiếp đến máy tính chạy card đồ họa GPU riêng để chạy các mô hình AI lớn nhất (FLUX.1 Dev, SD 3.5 Large, Midjourney-style) với thời gian tạo từ 30 giây đến 3 phút tùy ý.
- **Thuật toán tự động định tuyến thông minh (Semantic Auto-Router)**: Người dùng chỉ cần nhập ý tưởng; hệ thống tự động phân loại ngữ cảnh và kích hoạt mô hình tối ưu nhất:
  - *FLUX.1 Schnell*: Nghệ thuật cao cấp, phong cảnh giả tưởng, tranh sơn dầu, bối cảnh phức tạp.
  - *FLUX.1 Realism*: Chụp ảnh chân dung, ảnh đời thường, nhiếp ảnh điện ảnh, chi tiết da và ánh sáng studio.
  - *FLUX Anime*: Phong cách hoạt hình Nhật Bản, manga, truyện tranh, cel-shading.
  - *FLUX 3D Render*: Đồ họa 3D CGI, hoạt hình phong cách Pixar, mô hình Blender.
  - *SDXL Turbo*: Đồ họa tối giản, biểu tượng, logo, nét vẽ phác thảo phẳng.
- **Thiết kế tối giản (Minimalist Design)**: Loại bỏ toàn bộ emoji, sử dụng kiểu chữ và biểu tượng hệ thống SF Symbols trang nhã, không rườm rà.
- **Hiệu ứng AI phản hồi trực quan (AI Return Transition)**: Cập nhật từng giai đoạn xử lý (Phân tích ngữ nghĩa -> Kích hoạt mô hình -> Kết xuất ảnh) và chuyển cảnh xuất hiện ảnh mượt mà bằng hiệu ứng lò xo (Spring Animation).
- **Trải nghiệm gõ phím thuận tiện (Tap to Dismiss)**: Chạm vào bất kỳ vùng trống nào trên màn hình để ẩn bàn phím ngay lập tức.
- **Tùy chọn tỉ lệ khung hình (Aspect Ratio)**: Vuông (1:1), Dọc (9:16 - tối ưu hình nền điện thoại), Ngang (16:9).
- **Hỗ trợ song ngữ (Bilingual)**: Chuyển đổi linh hoạt giữa Tiếng Việt (VI) và English (EN) chỉ với 1 chạm.

---

## Cấu trúc thư mục / Project Structure

```
StealHex VN/
├── .github/
│   └── workflows/
│       └── ios-build.yml           # CI/CD Build & Sideload Release
├── iOSImageGenerator/
│   ├── iOSImageGeneratorApp.swift  # App Entry Point
│   ├── Localization.swift          # Trình quản lý song ngữ (VI / EN)
│   ├── PromptClassifier.swift      # Thuật toán phân tích ngữ nghĩa câu lệnh
│   ├── AIService.swift             # Kết nối cụm máy chủ AI (5 mô hình FLUX & SDXL)
│   ├── ImageGenerator.swift        # Cầu nối Apple Intelligence
│   ├── SettingsView.swift          # Cài đặt & Thông tin tác giả
│   ├── PromptImageView.swift       # Giao diện chính tối giản & hiệu ứng trả về
│   └── Assets.xcassets/            # AppIcon (1024x1024) & Bảng màu
├── iOSImageGenerator.xcodeproj/
└── README.md
```

---

## Cài đặt ứng dụng / Installation

### Tải file IPA cài đặt (Sideload)
1. Truy cập mục [Releases](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/releases).
2. Tải file **`StealHex_VN.ipa`** (hoặc `iOSImageGenerator.ipa`).
3. Cài đặt vào điện thoại thông qua **Sideloadly**, **TrollStore**, **AltStore**, **Scarlet**, hoặc **Feather**.

---

## Tác giả & Ghi nhận / Author & Credits

- **Tác giả phát triển (Author)**: **VanKhoa** ([@emlavankhoahienma-hue](https://github.com/emlavankhoahienma-hue))
- **Ý tưởng nguyên bản (Original Concept)**: [Adi Mizrahi (@mizadi)](https://github.com/mizadi/iOSImageGenerator)
- **Cơ sở hạ tầng AI**: Hugging Face Open Inference Cluster & Apple Intelligence

---

## Giấy phép / License

Phát hành theo giấy phép [MIT License](LICENSE).
