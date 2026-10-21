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
            onComplete?(true, "Đã lưu vào Album Ảnh / Saved to Photos")
        }
    }
}

struct PromptImageView: View {
    @ObservedObject var langManager = LanguageManager.shared
    @AppStorage("custom_server_url") private var customServerUrl: String = ""
    @AppStorage("hf_api_token") private var hfToken: String = ""

    @State private var prompt: String = ""
    @State private var selectedAspectRatio: AspectRatio = .square
    @State private var image: UIImage? = nil
    @State private var routedModelResult: ClassificationResult? = nil
    @State private var isLoading = false
    @State private var loadingStageText = ""
    @State private var errorMessage: String? = nil
    @State private var toastMessage: String? = nil
    @State private var showSettings = false
    @State private var imageSaver = ImageSaver()

    // Animation states
    @State private var imageReturned = false
    @State private var timer: Timer? = nil

    private var samplePrompts: [String] {
        if langManager.currentLanguage == .vietnamese {
            return [
                "Chân dung nghệ thuật cô gái Việt Nam trong tà áo dài trắng, ánh sáng điện ảnh",
                "Mèo phi hành gia trượt ván trong vũ trụ viễn tưởng, phong cách hoạt hình anime",
                "Mô hình đồ chơi 3D nhân vật hiệp sĩ mini đứng trên bàn gỗ",
                "Biểu tượng vector tối giản hình chim đại bàng sải cánh",
                "Thành phố tương lai rực rỡ với xe bay lúc hoàng hôn, tranh sơn dầu"
            ]
        } else {
            return [
                "Cinematic photorealistic portrait of an ancient warrior in misty bamboo forest",
                "Cyberpunk cat riding neon waves in cosmos, high quality anime aesthetic",
                "Stylized 3D render of a cute astronaut character, Blender Pixar style",
                "Minimalist vector logo emblem of a flying falcon, clean lines",
                "Futuristic metropolis with flying vehicles at twilight, oil on canvas"
            ]
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Minimalist Author Tagline (Only ONE title exists in navigationTitle)
                    HStack {
                        Label(langManager.tr("Tác giả: VanKhoa", "Author: VanKhoa"), systemImage: "checkmark.seal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)

                    // Prompt Input Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(langManager.tr("Câu lệnh mô tả (Prompt)", "Prompt Description"))
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            if !prompt.isEmpty {
                                Button(action: { prompt = "" }) {
                                    Text(langManager.tr("Xóa", "Clear"))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        TextField(
                            langManager.tr("Nhập ý tưởng hình ảnh bạn muốn tạo...", "Enter the image idea you want to create..."),
                            text: $prompt,
                            axis: .vertical
                        )
                        .lineLimit(2...5)
                        .submitLabel(.done)
                        .onSubmit {
                            hideKeyboard()
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
                                Button(action: {
                                    prompt = sample
                                    hideKeyboard()
                                }) {
                                    Text(sample)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray5))
                                        .foregroundColor(.primary)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

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
                        hideKeyboard()
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
                                 ? langManager.tr("Đang xử lý trí tuệ nhân tạo...", "Processing with AI...")
                                 : langManager.tr("Tạo ảnh", "Generate"))
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading ? Color.gray.opacity(0.35) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                    .padding(.horizontal)

                    // Toast message
                    if let toast = toastMessage {
                        Text(toast)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            .transition(.opacity)
                    }

                    // Result View / Progressive Loading Effect
                    if isLoading {
                        VStack(spacing: 14) {
                            ProgressView()
                                .scaleEffect(1.3)
                            Text(loadingStageText)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .animation(.easeInOut, value: loadingStageText)
                        }
                        .padding(.vertical, 36)
                    } else if let uiImage = image {
                        VStack(spacing: 12) {
                            // Smart Auto-Router Badge (AI Return Effect indicator)
                            if let classification = routedModelResult {
                                HStack(spacing: 6) {
                                    Image(systemName: "cpu")
                                        .font(.caption)
                                    Text(langManager.currentLanguage == .vietnamese ? classification.reasonVI : classification.reasonEN)
                                        .font(.caption.bold())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.accentColor.opacity(0.12))
                                .foregroundColor(.accentColor)
                                .cornerRadius(8)
                                .transition(.opacity)
                            }

                            // AI Generated Image with Smooth Return Transition
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 350, maxHeight: 440)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.accentColor.opacity(imageReturned ? 0.35 : 0.0), lineWidth: 1.5)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 14, x: 0, y: 7)
                                .scaleEffect(imageReturned ? 1.0 : 0.94)
                                .opacity(imageReturned ? 1.0 : 0.0)
                                .padding(.horizontal)

                            // Actions: Share, Save, Copy (clean icons, no emojis)
                            HStack(spacing: 10) {
                                ShareLink(
                                    item: Image(uiImage: uiImage),
                                    preview: SharePreview(prompt, image: Image(uiImage: uiImage))
                                ) {
                                    Label(langManager.tr("Chia sẻ", "Share"), systemImage: "square.and.arrow.up")
                                        .font(.subheadline)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { saveToPhotos(uiImage) }) {
                                    Label(langManager.tr("Lưu ảnh", "Save"), systemImage: "arrow.down.circle")
                                        .font(.subheadline)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { copyToClipboard(uiImage) }) {
                                    Label(langManager.tr("Sao chép", "Copy"), systemImage: "doc.on.doc")
                                        .font(.subheadline)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                        .padding(.top, 4)
                    } else if let error = errorMessage {
                        VStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text(langManager.tr("Không thể tạo hình ảnh", "Could Not Generate Image"))
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

                    Spacer(minLength: 40)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("StealHex VN")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Language Toggle (VI / EN)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        hideKeyboard()
                        withAnimation {
                            langManager.toggleLanguage()
                        }
                    }) {
                        Text(langManager.currentLanguage.code)
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                    }
                }

                // Settings
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        hideKeyboard()
                        showSettings = true
                    }) {
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

        hideKeyboard()
        isLoading = true
        image = nil
        imageReturned = false
        errorMessage = nil
        toastMessage = nil

        // Phase 1: Classification & Intent Detection
        loadingStageText = langManager.tr("Đang phân tích ngữ nghĩa câu lệnh...", "Analyzing prompt semantics...")
        let classification = PromptClassifier.classify(prompt: cleanPrompt)
        self.routedModelResult = classification

        // Phase 2: Route to specialized engine
        try? await Task.sleep(nanoseconds: 600_000_000)
        loadingStageText = langManager.tr("Kích hoạt mô hình \(classification.model.badgeText)...", "Engaging \(classification.model.badgeText) engine...")

        do {
            let result = try await AIService.generateImage(
                prompt: cleanPrompt,
                model: classification.model,
                aspectRatio: selectedAspectRatio,
                hfToken: hfToken,
                customServerUrl: customServerUrl
            )
            self.image = result
            // AI Return Effect: Smooth Spring Transition
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                self.imageReturned = true
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func saveToPhotos(_ uiImage: UIImage) {
        hideKeyboard()
        imageSaver.saveImage(uiImage) { success, message in
            withAnimation {
                self.toastMessage = message
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    if self.toastMessage == message {
                        self.toastMessage = nil
                    }
                }
            }
        }
    }

    private func copyToClipboard(_ uiImage: UIImage) {
        hideKeyboard()
        UIPasteboard.general.image = uiImage
        withAnimation {
            self.toastMessage = langManager.tr("Đã sao chép vào bộ nhớ tạm", "Copied to clipboard")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.toastMessage = nil
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    PromptImageView()
}
