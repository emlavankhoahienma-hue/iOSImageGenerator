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
                // Ngôn ngữ giao diện
                Section(header: Text(langManager.tr("Ngôn ngữ giao diện", "Interface Language"))) {
                    Picker(langManager.tr("Ngôn ngữ", "Language"), selection: $langManager.currentLanguage) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text("\(lang.code) - \(lang.name)").tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Thông tin tác giả
                Section(header: Text(langManager.tr("Thông tin tác giả", "Author Information"))) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.title3)
                                .foregroundColor(.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Tác giả: VanKhoa", "Author: VanKhoa"))
                                    .font(.headline)
                                Text("VanKhoaSWIFT • StealHex VN")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)

                        Divider()

                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(.secondary)
                            Text(langManager.tr("Ý tưởng nguyên bản: Adi Mizrahi", "Original Concept: Adi Mizrahi"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Thuật toán định tuyến tự động
                Section(header: Text(langManager.tr("Cơ chế trí tuệ nhân tạo", "AI Routing Engine"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "brain")
                                .foregroundColor(.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Tự động phân tích câu lệnh", "Automatic Prompt Analysis"))
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Hệ thống tự động nhận diện ý định và định tuyến đến 1 trong 5 mô hình AI chuyên biệt (FLUX.1 Schnell, Realism, Anime, 3D Render, SDXL Turbo).", "Automatically detects prompt intent and routes to 1 of 5 specialized AI models (FLUX.1 Schnell, Realism, Anime, 3D Render, SDXL Turbo)."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Token Hugging Face
                Section(
                    header: Text(langManager.tr("Tài khoản Hugging Face (Tùy chọn)", "Hugging Face Account (Optional)")),
                    footer: Text(langManager.tr("Mặc định ứng dụng kết nối trực tiếp đến cụm máy chủ xử lý không tốn phí. Bạn có thể dán mã token Hugging Face nếu muốn.", "By default the application routes requests through high-speed cloud clusters. You may enter your Hugging Face token optionally."))
                ) {
                    SecureField("hf_xxxxxxxxxxxxxxxxxxxxxx", text: $hfToken)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // Phiên bản
                Section(header: Text(langManager.tr("Thông tin ứng dụng", "App Information"))) {
                    HStack {
                        Text(langManager.tr("Tên ứng dụng", "App Name"))
                        Spacer()
                        Text("StealHex VN")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text(langManager.tr("Phiên bản", "Version"))
                        Spacer()
                        Text("2.5.0")
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
            .navigationTitle(langManager.tr("Cài đặt", "Settings"))
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
