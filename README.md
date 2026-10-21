# 🧠 iOSImageGenerator

[![iOS Sideload Build & Release](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/actions/workflows/ios-build.yml/badge.svg)](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/actions/workflows/ios-build.yml)
[![iOS 17.0+](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Device Support](https://img.shields.io/badge/Devices-iPhone%20XS%20%E2%9E%94%2017%20Pro%20Max-brightgreen.svg)](https://apple.com)
[![Hugging Face](https://img.shields.io/badge/AI%20Engine-FLUX.1%20%26%20SDXL-yellow.svg)](https://huggingface.co)
[![Author](https://img.shields.io/badge/Author-VanKhoa-orange.svg)](https://github.com/emlavankhoahienma-hue)
[![Bilingual](https://img.shields.io/badge/Language-%F0%9F%87%BB%F0%9F%87%B3%20Ti%E1%BA%BFng%20Vi%E1%BB%87t%20%7C%20%F0%9F%87%AC%F0%9F%87%A7%20English-blueviolet.svg)](#)

Ứng dụng tạo ảnh nghệ thuật AI native bằng SwiftUI, hỗ trợ toàn diện từ **iPhone XS đến iPhone 17 Pro Max** (iOS 17.0+). Tích hợp các mô hình AI mạnh nhất thế giới từ **Hugging Face** (FLUX.1 Schnell, FLUX.1 Realism, FLUX Anime, SDXL) và **Apple Intelligence** (On-device trên iPhone 15 Pro+). Hỗ trợ song ngữ **Tiếng Việt 🇻🇳 & English 🇬🇧**.

Native SwiftUI AI image generation app supporting all devices from **iPhone XS to iPhone 17 Pro Max** (iOS 17.0+). Powered by state-of-the-art **Hugging Face** models (FLUX.1 Schnell, FLUX.1 Realism, FLUX Anime, SDXL) and **Apple Intelligence** on supported hardware. Full bilingual support (**Tiếng Việt 🇻🇳 & English 🇬🇧**).

---

## 📸 Tính năng nổi bật / Key Features

- 📱 **Hỗ trợ từ iPhone XS ➔ 17 Pro Max**: Không giới hạn phần cứng, hoạt động mượt mà trên tất cả các dòng máy chạy iOS 17+.
- 🧠 **Mô hình AI đỉnh cao từ Hugging Face**:
  - 🔥 **FLUX.1 Schnell**: Mô hình thế hệ mới từ Black Forest Labs với chất lượng hình ảnh và chi tiết vượt trội.
  - 📸 **FLUX.1 Realism**: Chuyên ảnh chân dung điện ảnh, độ chân thực cao, ánh sáng studio.
  - 🎌 **FLUX Anime / Manga**: Tạo phong cách anime Nhật Bản sắc nét, sống động.
  - 🧊 **FLUX 3D Render**: Mô phỏng 3D CGI hoạt hình phong cách Pixar.
  - ⚡ **SDXL Turbo**: Tốc độ kết xuất tức thì (1-3 giây).
  - 🍎 **Apple Intelligence**: Khả dụng trên iPhone 15 Pro, 16, 17 chạy iOS 18.4+.
- 🌐 **Giao diện Song ngữ Anh - Việt (Bilingual UI)**: Chuyển đổi ngôn ngữ tức thì với 1 chạm giữa 🇻🇳 Tiếng Việt và 🇬🇧 English.
- 📐 **Tùy chọn tỉ lệ khung hình (Aspect Ratio)**:
  - `1:1 Vuông` (Square, 1024x1024)
  - `9:16 Dọc` (Portrait, 768x1344 - Tối ưu cho hình nền iPhone)
  - `16:9 Ngang` (Landscape, 1344x768)
- 💡 **Gợi ý Prompt mẫu thông minh**: Tích hợp các prompt nghệ thuật mẫu bằng cả tiếng Việt và tiếng Anh.
- 📤 **Chia sẻ & Lưu ảnh nhanh**: Hỗ trợ native `ShareLink` (AirDrop, Zalo, Messages), Lưu vào Album Ảnh (`Photos`), và Sao chép vào bộ nhớ tạm.
- 📦 **Tự động build file IPA qua GitHub Actions**: Tải về và cài đặt trực tiếp không cần máy Mac.

---

## 📱 Khả năng tương thích thiết bị / Device Compatibility

| Dòng máy / Device Series | Trạng thái / Status | Động cơ AI / AI Engine |
|---|---|---|
| **iPhone XS / XS Max / XR** | ✅ Hỗ trợ đầy đủ (iOS 17+) | Hugging Face (FLUX.1 / SDXL) |
| **iPhone 11 / 11 Pro / 11 Pro Max** | ✅ Hỗ trợ đầy đủ (iOS 17+) | Hugging Face (FLUX.1 / SDXL) |
| **iPhone 12 / 13 / 14 Series** | ✅ Hỗ trợ đầy đủ (iOS 17+) | Hugging Face (FLUX.1 / SDXL) |
| **iPhone 15 (Standard / Plus)** | ✅ Hỗ trợ đầy đủ (iOS 17+) | Hugging Face (FLUX.1 / SDXL) |
| **iPhone 15 Pro / Pro Max** | ✅ Hỗ trợ đầy đủ (iOS 17+) | Hugging Face + Apple Intelligence |
| **iPhone 16 Series** | ✅ Hỗ trợ đầy đủ (iOS 18+) | Hugging Face + Apple Intelligence |
| **iPhone 17 Series / 17 Pro Max** | ✅ Hỗ trợ đầy đủ (iOS 18+) | Hugging Face + Apple Intelligence |

---

## 🏗️ Cấu trúc dự án / Project Structure

```
iOSImageGenerator/
├── .github/
│   └── workflows/
│       └── ios-build.yml           # GitHub Actions CI workflow (macOS 15 + Xcode)
├── iOSImageGenerator/
│   ├── iOSImageGeneratorApp.swift  # SwiftUI App root
│   ├── Localization.swift          # Song ngữ Anh - Việt (Bilingual Manager)
│   ├── AIService.swift             # Hugging Face & Cloud AI Engine (FLUX.1, SDXL)
│   ├── ImageGenerator.swift        # Apple Intelligence Bridge (ImagePlayground)
│   ├── SettingsView.swift          # Cài đặt, Thông tin Tác giả & API Token
│   ├── PromptImageView.swift       # Giao diện chính: Prompt, Model, Ratio, Preview
│   └── Assets.xcassets/            # AppIcon (1024x1024) & Accent Colors
├── iOSImageGenerator.xcodeproj/
│   ├── project.pbxproj             # Deployment target iOS 17.0
│   └── xcshareddata/
│       └── xcschemes/
│           └── iOSImageGenerator.xcscheme
└── README.md
```

---

## 🛠️ Hướng dẫn cài đặt / How to Install

### Cách 1: Tải file IPA có sẵn (Sideload không cần Mac)
1. Truy cập mục [Releases](https://github.com/emlavankhoahienma-hue/iOSImageGenerator/releases).
2. Tải file **`iOSImageGenerator.ipa`**.
3. Cài đặt vào iPhone bằng:
   - **TrollStore** (nếu thiết bị hỗ trợ)
   - **Sideloadly** (qua máy tính Windows / Mac)
   - **AltStore / Feather / Scarlet**

### Cách 2: Tự build qua Xcode
```bash
git clone https://github.com/emlavankhoahienma-hue/iOSImageGenerator.git
cd iOSImageGenerator
open iOSImageGenerator.xcodeproj
```

---

## 👨‍💻 Tác giả & Ghi nhận / Author & Credits

- **Tác giả phát triển & Nâng cấp (Author)**: **VanKhoa** ([@emlavankhoahienma-hue](https://github.com/emlavankhoahienma-hue))
- **Ý tưởng gốc (Original Concept)**: [Adi Mizrahi (@mizadi)](https://github.com/mizadi/iOSImageGenerator)
- **Nền tảng AI**: [Hugging Face](https://huggingface.co) (FLUX.1 by Black Forest Labs, SDXL by Stability AI) & Apple Intelligence

---

## 📄 Giấy phép / License

Dự án được phân phối dưới giấy phép [MIT License](LICENSE).
