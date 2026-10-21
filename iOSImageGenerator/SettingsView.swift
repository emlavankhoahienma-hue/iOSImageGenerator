//
//  SettingsView.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var langManager = LanguageManager.shared
    @AppStorage("hf_api_token") private var hfToken: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                // Section: Ngôn ngữ / Language
                Section(header: Text(langManager.tr("Ngôn ngữ giao diện", "Interface Language"))) {
                    Picker(langManager.tr("Ngôn ngữ", "Language"), selection: $langManager.currentLanguage) {
                        ForEach(AppLanguage.allCases) { lang in
                            HStack {
                                Text(lang.flag)
                                Text(lang.name)
                            }
                            .tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Section: Tác giả / Author
                Section(header: Text(langManager.tr("Thông tin tác giả", "Author Information"))) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Tác giả: VanKhoa", "Author: VanKhoa"))
                                    .font(.headline)
                                Text("VanKhoaSWIFT • emlavankhoahienma-hue")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)

                        Divider()

                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                            Text(langManager.tr("Ý tưởng gốc: Adi Mizrahi (@mizadi)", "Original Concept: Adi Mizrahi (@mizadi)"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Section: Độ tương thích thiết bị / Device Compatibility
                Section(header: Text(langManager.tr("Khả năng tương thích", "Device Compatibility"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "iphone.gen3")
                                .foregroundColor(.green)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Hỗ trợ mọi iPhone từ XS ➔ 17 Pro Max", "Supports all iPhones from XS ➔ 17 Pro Max"))
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Chạy trên iOS 17.0 trở lên. Không yêu cầu chip A17 Pro.", "Runs on iOS 17.0+. No A17 Pro required."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        HStack(alignment: .top) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Động cơ AI Hugging Face (FLUX.1)", "Hugging Face AI Engine (FLUX.1)"))
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Sử dụng các mô hình AI mạnh nhất thế giới (FLUX.1 Schnell, Realism, Anime) trực tuyến không tốn RAM máy.", "Uses top global open models (FLUX.1 Schnell, Realism, Anime) in cloud without device RAM limits."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        HStack(alignment: .top) {
                            Image(systemName: "apple.logo")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Apple Intelligence (On-Device)")
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Khả dụng trên iPhone 15 Pro, 16, 17 với iOS 18.4+.", "Available on iPhone 15 Pro, 16, 17 with iOS 18.4+."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Section: Hugging Face Token (Optional)
                Section(
                    header: Text(langManager.tr("Tài khoản Hugging Face (Tùy chọn)", "Hugging Face Account (Optional)")),
                    footer: Text(langManager.tr("Mặc định app sử dụng cụm máy chủ AI miễn phí không cần token. Nếu bạn có Hugging Face User Access Token riêng, bạn có thể dán vào đây.", "By default the app uses free cloud AI endpoints. If you have your own Hugging Face User Token, you can enter it here."))
                ) {
                    SecureField("hf_xxxxxxxxxxxxxxxxxxxxxx", text: $hfToken)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // Section: Giới thiệu / About
                Section(header: Text(langManager.tr("Về ứng dụng", "About App"))) {
                    HStack {
                        Text(langManager.tr("Phiên bản", "Version"))
                        Spacer()
                        Text("2.0.0 (Build 2026)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(langManager.tr("Giấy phép", "License"))
                        Spacer()
                        Text("MIT License")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(langManager.tr("Cài đặt & Tác giả", "Settings & Author"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(langManager.tr("Xong", "Done")) {
                        dismiss()
                    }
                }
            }
        }
    }
}
