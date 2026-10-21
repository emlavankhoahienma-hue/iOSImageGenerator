# 🧠 Image iOSImageGenerator By VanKhoaSWIFT

[![iOS Sideload Build & Release](https://github.com/emlavankhoahienma-hue/Image-iOSImageGenerator-By-VanKhoaSWIFT/actions/workflows/ios-build.yml/badge.svg)](https://github.com/emlavankhoahienma-hue/Image-iOSImageGenerator-By-VanKhoaSWIFT/actions/workflows/ios-build.yml)
[![iOS 18.2+](https://img.shields.io/badge/iOS-18.2%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Xcode 16+](https://img.shields.io/badge/Xcode-16%2B-blueviolet.svg)](https://developer.apple.com/xcode/)
[![Apple Intelligence](https://img.shields.io/badge/Apple%20Intelligence-ImagePlayground-success.svg)](https://developer.apple.com/apple-intelligence/)

A native SwiftUI application powered by Apple's on-device **ImagePlayground** framework (Apple Intelligence). Effortlessly transform creative prompts into stunning illustrations, animations, or sketches right on your iPhone — private, fast, and completely free of API keys or cloud subscriptions.

---

## 📸 Key Features

- 🎨 **Prompt-to-Image Generation**: Turn any natural language description into artwork in seconds.
- 🎭 **Multiple Artistic Styles**:
  - `Illustration`: Distinctive graphic illustration style.
  - `Animation`: Dynamic 3D-styled animated aesthetics.
  - `Sketch`: Artistic hand-drawn sketch styling.
- ⚡ **100% On-Device AI**: Powered by Apple Intelligence via `ImagePlayground.ImageCreator`. No API tokens, no monthly fees, and zero cloud uploads.
- 📤 **Export & Share**:
  - Native iOS `ShareLink` integration (AirDrop, Messages, Social Apps).
  - One-tap "Save to Photos" (`UIImageWriteToSavedPhotosAlbum`).
  - One-tap "Copy to Clipboard".
- 📦 **Automated Sideload IPA Releases**: GitHub Actions CI automatically builds unsigned `.ipa` packages ready for Sideloadly, TrollStore, AltStore, Feather, and Scarlet.

---

## 📱 System Requirements

| Requirement | Specification |
|---|---|
| **OS** | iOS 18.2+ / iPadOS 18.2+ |
| **Hardware** | Apple Intelligence compatible device (iPhone 15 Pro, iPhone 15 Pro Max, iPhone 16 series, or M-series iPad/Mac) |
| **Xcode (for building)** | Xcode 16.1+ / Xcode 16.2+ |
| **Deployment Target** | iOS 18.2 |

---

## 🏗️ Architecture & Project Structure

```
Image-iOSImageGenerator-By-VanKhoaSWIFT/
├── .github/
│   └── workflows/
│       └── ios-build.yml           # Automated macOS 15 + Xcode 16 CI workflow
├── iOSImageGenerator/
│   ├── iOSImageGeneratorApp.swift  # SwiftUI App entry point
│   ├── ImageGenerator.swift        # ImagePlayground API integration & style mapping
│   ├── PromptImageView.swift       # SwiftUI UI: Prompt input, style picker, preview & actions
│   └── Assets.xcassets/            # AppIcon (1024x1024) & Accent colors
├── iOSImageGenerator.xcodeproj/
│   ├── project.pbxproj             # Configured for iOS 18.2, automatic Info.plist generation
│   └── xcshareddata/
│       └── xcschemes/
│           └── iOSImageGenerator.xcscheme # Shared scheme for CI/CD builds
└── README.md
```

---

## 🛠️ How to Build & Install

### Method 1: Sideload pre-built IPA (No Mac required)
1. Head to the [Releases](https://github.com/emlavankhoahienma-hue/Image-iOSImageGenerator-By-VanKhoaSWIFT/releases) or GitHub Actions Artifacts.
2. Download `Image_iOSImageGenerator_By_VanKhoaSWIFT.ipa`.
3. Sideload onto your iPhone using:
   - **TrollStore** (if supported on your iOS version)
   - **Sideloadly** (macOS / Windows via USB/Wi-Fi)
   - **AltStore / Feather / Scarlet**

### Method 2: Build locally in Xcode
```bash
git clone https://github.com/emlavankhoahienma-hue/Image-iOSImageGenerator-By-VanKhoaSWIFT.git
cd Image-iOSImageGenerator-By-VanKhoaSWIFT
open iOSImageGenerator.xcodeproj
```
Select your Apple Development Team in Signing & Capabilities, connect your iPhone running iOS 18.2+, and click **Run**.

### Method 3: Command-line build (unsigned)
```bash
xcodebuild build \
  -project iOSImageGenerator.xcodeproj \
  -scheme iOSImageGenerator \
  -destination 'generic/platform=iOS' \
  -configuration Release \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO
```

---

## 🚀 Usage

1. Launch **Image iOSImageGenerator By VanKhoaSWIFT** on your iPhone.
2. Enter any creative prompt (or pick one of the sample prompts).
3. Select an artistic style (`Illustration`, `Animation`, or `Sketch`).
4. Tap **Generate Image**.
5. Once created, tap **Share**, **Save**, or **Copy**.

---

## 👨‍💻 Author & Credits

- **Original Base Concept**: [Adi Mizrahi (mizadi)](https://github.com/mizadi/iOSImageGenerator)
- **Enhanced, Sideload & CI/CD Pipeline**: **VanKhoaSWIFT** (`emlavankhoahienma-hue`)
- **Framework**: Apple ImagePlayground / Apple Intelligence

---

## 📄 License

This project is licensed under the MIT License.
