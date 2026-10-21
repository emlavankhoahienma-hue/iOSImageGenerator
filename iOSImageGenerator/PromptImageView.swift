//
//  PromptImageView.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import SwiftUI

final class ImageSaver: NSObject {
    private var onComplete: ((Bool, String) -> Void)?

    func saveImage(_ image: UIImage, completion: @escaping (Bool, String) -> Void) {
        self.onComplete = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSaving(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func didFinishSaving(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            onComplete?(false, error.localizedDescription)
        } else {
            onComplete?(true, "Đã lưu vào Album Ảnh! / Saved to Photos!")
        }
    }
}

struct PromptImageView: View {
    @ObservedObject var langManager = LanguageManager.shared
    @AppStorage("hf_api_token") private var hfToken: String = ""

    @State private var prompt: String = ""
    @State private var selectedModel: AIModelType = .fluxSchnell
    @State private var selectedAspectRatio: AspectRatio = .square
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var toastMessage: String? = nil
    @State private var showSettings = false
    @State private var imageSaver = ImageSaver()

    private var samplePrompts: [String] {
        if langManager.currentLanguage == .vietnamese {
            return [
                "Mèo phi hành gia trượt ván trong vũ trụ cyberpunk",
                "Rồng vàng bay trên vịnh Hạ Long lúc hoàng hôn rực rỡ, tranh sơn dầu",
                "Chân dung thiếu nữ Việt Nam áo dài trắng trong vườn hoa mai ngày Tết, điện ảnh 8k",
                "Thành phố Sài Gòn tương lai năm 2099 với xe bay và ánh đèn neon"
            ]
        } else {
            return [
                "An astronaut cat surfing neon waves in a cyberpunk cosmos, 8k",
                "Golden dragon soaring over misty limestone peaks at sunset, oil painting",
                "Cinematic photorealistic portrait of an ancient warrior in bamboo forest",
                "Futuristic Asian metropolis in year 2099 with flying vehicles and neon glow"
            ]
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Header Card: Author & Compatibility Badge
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                            Text("iOSImageGenerator")
                                .font(.title3.bold())
                        }

                        HStack(spacing: 8) {
                            Text(langManager.tr("Tác giả: VanKhoa", "Author: VanKhoa"))
                                .font(.caption.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundColor(.accentColor)
                                .cornerRadius(6)

                            Text(langManager.tr("iPhone XS ➔ 17 Pro Max", "iPhone XS ➔ 17 Pro Max"))
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.top, 4)

                    // Prompt Input
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(langManager.tr("Câu lệnh mô tả (Prompt)", "Prompt Description"))
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            if !prompt.isEmpty {
                                Button(langManager.tr("Xóa", "Clear")) {
                                    prompt = ""
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                        }

                        HStack(alignment: .top) {
                            TextField(
                                langManager.tr("Mô tả hình ảnh bạn muốn tạo (tiếng Việt hoặc tiếng Anh)...", "Describe the image you want to generate..."),
                                text: $prompt,
                                axis: .vertical
                            )
                            .lineLimit(2...5)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Prompt Suggestions Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(samplePrompts, id: \.self) { sample in
                                Button(action: { prompt = sample }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "lightbulb.fill")
                                            .font(.caption2)
                                            .foregroundColor(.yellow)
                                        Text(sample)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.primary)
                                    .cornerRadius(14)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Model Selector
                    VStack(alignment: .leading, spacing: 6) {
                        Text(langManager.tr("Mô hình AI (Hugging Face / Apple)", "AI Model (Hugging Face / Apple)"))
                            .font(.caption.bold())
                            .foregroundColor(.secondary)

                        Menu {
                            ForEach(AIModelType.allCases) { model in
                                Button(action: { selectedModel = model }) {
                                    HStack {
                                        Text("\(model.badge) \(model.displayName(lang: langManager.currentLanguage))")
                                        if selectedModel == model {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(selectedModel.badge) \(selectedModel.displayName(lang: langManager.currentLanguage))")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    // Aspect Ratio Selector
                    VStack(alignment: .leading, spacing: 6) {
                        Text(langManager.tr("Tỉ lệ khung hình", "Aspect Ratio"))
                            .font(.caption.bold())
                            .foregroundColor(.secondary)

                        Picker("Aspect Ratio", selection: $selectedAspectRatio) {
                            ForEach(AspectRatio.allCases) { ratio in
                                Text(ratio.label(lang: langManager.currentLanguage)).tag(ratio)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)

                    // Generate Button
                    Button(action: {
                        Task {
                            await generateImage()
                        }
                    }) {
                        HStack(spacing: 8) {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "wand.and.stars")
                            }
                            Text(isLoading
                                 ? langManager.tr("Đang vẽ tác phẩm AI...", "Generating AI Artwork...")
                                 : langManager.tr("Tạo ảnh AI", "Generate AI Image"))
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(prompt.trimmingCharacters(in: .whitespaces).isEmpty || isLoading ? Color.gray.opacity(0.4) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(prompt.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                    .padding(.horizontal)

                    // Toast message
                    if let toast = toastMessage {
                        Text(toast)
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.horizontal)
                            .transition(.opacity)
                    }

                    // Result View / Loading
                    if isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.4)
                            Text(langManager.tr("Mô hình AI đang kết xuất hình ảnh từ câu lệnh của bạn...", "AI model is rendering image from your prompt..."))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 30)
                    } else if let uiImage = image {
                        VStack(spacing: 14) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 350, maxHeight: 420)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
                                .padding(.horizontal)

                            // Actions: Share, Save, Copy
                            HStack(spacing: 10) {
                                ShareLink(
                                    item: Image(uiImage: uiImage),
                                    preview: SharePreview(prompt, image: Image(uiImage: uiImage))
                                ) {
                                    Label(langManager.tr("Chia sẻ", "Share"), systemImage: "square.and.arrow.up")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { saveToPhotos(uiImage) }) {
                                    Label(langManager.tr("Lưu ảnh", "Save"), systemImage: "arrow.down.circle")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { copyToClipboard(uiImage) }) {
                                    Label(langManager.tr("Sao chép", "Copy"), systemImage: "doc.on.doc")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    } else if let error = errorMessage {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title)
                                .foregroundColor(.orange)
                            Text(langManager.tr("Lỗi khi tạo ảnh", "Could Not Generate Image"))
                                .font(.headline)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 30)
                }
            }
            .navigationTitle("iOSImageGenerator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Quick Language Toggle: 🇻🇳 / 🇬🇧
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            langManager.toggleLanguage()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(langManager.currentLanguage.flag)
                            Text(langManager.currentLanguage.name)
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }

                // Settings & Author Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private func generateImage() async {
        let cleanPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanPrompt.isEmpty else { return }

        isLoading = true
        image = nil
        errorMessage = nil
        toastMessage = nil

        do {
            let result = try await AIService.generateImage(
                prompt: cleanPrompt,
                model: selectedModel,
                aspectRatio: selectedAspectRatio,
                hfToken: hfToken
            )
            self.image = result
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func saveToPhotos(_ uiImage: UIImage) {
        imageSaver.saveImage(uiImage) { success, message in
            withAnimation {
                self.toastMessage = message
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    if self.toastMessage == message {
                        self.toastMessage = nil
                    }
                }
            }
        }
    }

    private func copyToClipboard(_ uiImage: UIImage) {
        UIPasteboard.general.image = uiImage
        withAnimation {
            self.toastMessage = langManager.tr("Đã sao chép vào clipboard!", "Copied to clipboard!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                if self.toastMessage == self.langManager.tr("Đã sao chép vào clipboard!", "Copied to clipboard!") {
                    self.toastMessage = nil
                }
            }
        }
    }
}

#Preview {
    PromptImageView()
}
