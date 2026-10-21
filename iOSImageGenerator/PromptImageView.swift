//
//  PromptImageView.swift
//  iOSImageGenerator
//
//  Created by Adi Mizrahi on 08/07/2025.
//  Updated by VanKhoaSWIFT
//

import SwiftUI
import ImagePlayground

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
            onComplete?(true, "Image saved to Photos!")
        }
    }
}

@available(iOS 18.4, *)
struct PromptImageView: View {
    @State private var prompt: String = ""
    @State private var selectedStyle: GenerationStyle = .illustration
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var toastMessage: String? = nil
    @State private var imageSaver = ImageSaver()

    private let samplePrompts = [
        "A cute cat wearing sunglasses surfing a wave",
        "A neon cyber city at twilight with flying cars",
        "An astronaut sipping coffee on Mars"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Subtitle
                    VStack(spacing: 4) {
                        Text("Image iOSImageGenerator")
                            .font(.title2.bold())
                        Text("By VanKhoaSWIFT • Powered by Apple Intelligence")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)

                    // Prompt Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prompt")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        HStack {
                            TextField("Enter your prompt...", text: $prompt, axis: .vertical)
                                .lineLimit(1...4)
                            if !prompt.isEmpty {
                                Button(action: { prompt = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Sample prompt pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(samplePrompts, id: \.self) { sample in
                                Button(action: { prompt = sample }) {
                                    Text(sample)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray5))
                                        .foregroundColor(.primary)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Style Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Style")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        Picker("Style", selection: $selectedStyle) {
                            ForEach(GenerationStyle.allCases) { style in
                                Text(style.rawValue).tag(style)
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
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .padding(.trailing, 6)
                            } else {
                                Image(systemName: "sparkles")
                            }
                            Text(isLoading ? "Generating with AI..." : "Generate Image")
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
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding(.horizontal)
                            .transition(.opacity)
                    }

                    // Loading or Result View
                    if isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.3)
                            Text("Apple Intelligence is painting your idea...")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 30)
                    } else if let uiImage = image {
                        VStack(spacing: 14) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 340, maxHeight: 340)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                                .padding(.horizontal)

                            // Actions: Share, Save, Copy
                            HStack(spacing: 12) {
                                ShareLink(item: Image(uiImage: uiImage), preview: SharePreview(prompt, image: Image(uiImage: uiImage))) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 14)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { saveToPhotos(uiImage) }) {
                                    Label("Save", systemImage: "arrow.down.circle")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 14)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }

                                Button(action: { copyToClipboard(uiImage) }) {
                                    Label("Copy", systemImage: "doc.on.doc")
                                        .font(.subheadline.bold())
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 14)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    } else if let error = errorMessage {
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Could not generate image")
                                .font(.headline)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Text("Note: ImagePlayground requires iOS 18.4+ and an Apple Intelligence-compatible device (iPhone 15 Pro, iPhone 16 series, or M-series iPad).")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
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
        }
    }

    private func generateImage() async {
        let cleanPrompt = prompt.trimmingCharacters(in: .whitespaces)
        guard !cleanPrompt.isEmpty else { return }

        isLoading = true
        image = nil
        errorMessage = nil
        toastMessage = nil

        do {
            let result = try await ImageGenerator.generate(from: cleanPrompt, style: selectedStyle.playgroundStyle)
            if let result = result {
                self.image = result
            } else {
                self.errorMessage = "No image was returned by ImagePlayground."
            }
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
            self.toastMessage = "Copied to clipboard!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                if self.toastMessage == "Copied to clipboard!" {
                    self.toastMessage = nil
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 18.4, *) {
        PromptImageView()
    } else {
        Text("Requires iOS 18.4+")
    }
}
