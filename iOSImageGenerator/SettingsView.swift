//
//  SettingsView.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var langManager = LanguageManager.shared
    @AppStorage("custom_server_url") private var customServerUrl: String = ""
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

                // Máy chủ AI cá nhân (Local PC / ComfyUI / Automatic1111)
                Section(
                    header: Text(langManager.tr("Máy chủ AI cá nhân (Tùy chọn)", "Custom AI Server (Optional)")),
                    footer: Text(langManager.tr("Dành cho người dùng chạy Stable Diffusion / FLUX trên máy tính cá nhân (Automatic1111, ComfyUI, Forge, ngrok). Nhập địa chỉ IP hoặc URL của bạn (ví dụ: http://192.168.1.5:7860). Thời gian xử lý từ 30 giây đến 3 phút tùy sức mạnh GPU.", "For users running local SD/FLUX on PC (Automatic1111, ComfyUI, Forge, ngrok). Enter your IP or URL (e.g. http://192.168.1.5:7860). Processing time 30s - 3m depending on GPU."))
                ) {
                    TextField("http://192.168.1.x:7860", text: $customServerUrl)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
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

                // Cơ chế AI
                Section(header: Text(langManager.tr("Cơ chế trí tuệ nhân tạo", "AI Routing Engine"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Bộ tối ưu ngữ nghĩa Prompt (PromptEngine)", "Semantic Prompt Engine"))
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Tự động dịch thuật và làm giàu ngữ cảnh câu lệnh tiếng Việt thành các thông số kỹ thuật điện ảnh, ánh sáng studio và chi tiết siêu nét 8K.", "Automatically translates and enriches prompts into cinematic lighting, studio optics, and 8K visual parameters."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        HStack(alignment: .top) {
                            Image(systemName: "brain")
                                .foregroundColor(.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(langManager.tr("Tự động phân loại 5 phong cách", "Auto-Classification"))
                                    .font(.subheadline.bold())
                                Text(langManager.tr("Nhận diện ý định tạo ảnh Chân thực, Anime, 3D Render, hay Đồ họa tối giản để áp dụng bộ lọc phù hợp nhất.", "Detects intent for Photorealism, Anime, 3D Render, or Minimalist to apply the optimal style filters."))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
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
                        Text("3.1.0")
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
