//
//  AIService.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import Foundation
import UIKit

enum AIModelType: String, CaseIterable, Identifiable {
    case fluxSchnell = "flux"
    case fluxRealism = "flux-realism"
    case fluxAnime = "flux-anime"
    case flux3D = "flux-3d"
    case sdxlTurbo = "turbo"
    case appleIntelligence = "apple_intelligence"

    var id: String { rawValue }

    func displayName(lang: AppLanguage) -> String {
        switch self {
        case .fluxSchnell:
            return lang == .vietnamese ? "FLUX.1 Schnell (Mạnh nhất)" : "FLUX.1 Schnell (Flagship)"
        case .fluxRealism:
            return lang == .vietnamese ? "FLUX.1 Chân Thực (Cinematic)" : "FLUX.1 Realism (Cinematic)"
        case .fluxAnime:
            return "FLUX Anime / Manga"
        case .flux3D:
            return "FLUX 3D Render"
        case .sdxlTurbo:
            return lang == .vietnamese ? "SDXL Turbo (Tốc độ cao)" : "SDXL Turbo (Ultra Fast)"
        case .appleIntelligence:
            return "Apple Intelligence"
        }
    }

    var badgeText: String {
        switch self {
        case .fluxSchnell: return "FLUX.1"
        case .fluxRealism: return "Realism"
        case .fluxAnime: return "Anime"
        case .flux3D: return "3D CGI"
        case .sdxlTurbo: return "Turbo"
        case .appleIntelligence: return "Apple"
        }
    }
}

enum AspectRatio: String, CaseIterable, Identifiable {
    case square = "1:1"
    case portrait = "9:16"
    case landscape = "16:9"

    var id: String { rawValue }

    var dimensions: (width: Int, height: Int) {
        switch self {
        case .square: return (1024, 1024)
        case .portrait: return (768, 1344)
        case .landscape: return (1344, 768)
        }
    }

    func label(lang: AppLanguage) -> String {
        switch self {
        case .square: return lang == .vietnamese ? "Vuông (1:1)" : "Square (1:1)"
        case .portrait: return lang == .vietnamese ? "Dọc (9:16)" : "Portrait (9:16)"
        case .landscape: return lang == .vietnamese ? "Ngang (16:9)" : "Landscape (16:9)"
        }
    }
}

enum AIService {
    static func generateImage(
        prompt: String,
        model: AIModelType,
        aspectRatio: AspectRatio,
        hfToken: String? = nil
    ) async throws -> UIImage {
        let cleanPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanPrompt.isEmpty else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Prompt cannot be empty"])
        }

        // On-Device Apple Intelligence path (only when explicitly selected and available)
        if model == .appleIntelligence {
            #if canImport(ImagePlayground)
            if #available(iOS 18.4, *) {
                if let image = try await AppleIntelligenceBridge.generate(from: cleanPrompt) {
                    return image
                }
            }
            #endif
        }

        let dims = aspectRatio.dimensions
        let seed = Int.random(in: 1...9999999)

        // Try direct Hugging Face Inference API if user provided an HF Token
        if let token = hfToken?.trimmingCharacters(in: .whitespacesAndNewlines), !token.isEmpty {
            if let image = try? await callHuggingFaceAPI(prompt: cleanPrompt, token: token) {
                return image
            }
        }

        // High-performance Cloud AI Engine (Hugging Face FLUX.1 / SDXL models)
        return try await callPollinationsEngine(
            prompt: cleanPrompt,
            model: model.rawValue,
            width: dims.width,
            height: dims.height,
            seed: seed
        )
    }

    private static func callPollinationsEngine(
        prompt: String,
        model: String,
        width: Int,
        height: Int,
        seed: Int
    ) async throws -> UIImage {
        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid prompt encoding"])
        }

        let modelParam = (model == "apple_intelligence") ? "flux" : model
        let urlString = "https://image.pollinations.ai/prompt/\(encodedPrompt)?model=\(modelParam)&width=\(width)&height=\(height)&nologo=true&seed=\(seed)"

        guard let url = URL(string: urlString) else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL created"])
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 45
        request.setValue("StealHexVN/2.0 (iPhone; VanKhoa)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "AIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server response error"])
        }

        guard let uiImage = UIImage(data: data) else {
            throw NSError(domain: "AIService", code: 422, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
        }

        return uiImage
    }

    private static func callHuggingFaceAPI(prompt: String, token: String) async throws -> UIImage? {
        let endpoint = "https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-schnell"
        guard let url = URL(string: endpoint) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 45
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["inputs": prompt]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return UIImage(data: data)
        }
        return nil
    }
}
