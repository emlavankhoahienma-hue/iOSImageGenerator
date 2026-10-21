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
        hfToken: String? = nil,
        customServerUrl: String? = nil
    ) async throws -> UIImage {
        let cleanPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanPrompt.isEmpty else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Prompt cannot be empty"])
        }

        // 1. On-Device Semantic Prompt Enhancement (translates & enriches Vietnamese / short prompts)
        let enhancedPrompt = PromptEngine.enhancePrompt(rawPrompt: cleanPrompt, model: model)
        let dims = aspectRatio.dimensions
        let seed = Int.random(in: 1...99999999)

        // 2. Custom Local / Private Server (Automatic1111 / ComfyUI / Forge on user's PC or cloud)
        if let server = customServerUrl?.trimmingCharacters(in: .whitespacesAndNewlines), !server.isEmpty {
            if let customImage = try? await callCustomServer(serverUrl: server, prompt: enhancedPrompt, width: dims.width, height: dims.height) {
                return customImage
            }
        }

        // 3. Apple Intelligence path (only when explicitly selected and hardware supports it)
        if model == .appleIntelligence {
            #if canImport(ImagePlayground)
            if #available(iOS 18.4, *) {
                if let image = try await AppleIntelligenceBridge.generate(from: cleanPrompt) {
                    return image
                }
            }
            #endif
        }

        // 4. Direct Cloud Generation using Enhanced Semantic Prompt
        return try await callDirectEngine(
            prompt: enhancedPrompt,
            width: dims.width,
            height: dims.height,
            seed: seed
        )
    }

    private static func callCustomServer(
        serverUrl: String,
        prompt: String,
        width: Int,
        height: Int
    ) async throws -> UIImage? {
        var base = serverUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if !base.hasPrefix("http://") && !base.hasPrefix("https://") {
            base = "http://" + base
        }
        guard let url = URL(string: "\(base)/sdapi/v1/txt2img") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 180 // Up to 3 minutes for local GPU processing
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "prompt": prompt,
            "negative_prompt": "blurry, low quality, bad anatomy, deformed limbs, artifacts, watermarks, ugly",
            "steps": 25,
            "width": width,
            "height": height
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let images = json["images"] as? [String],
           let firstBase64 = images.first,
           let imageData = Data(base64Encoded: firstBase64),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }

        return nil
    }

    private static func callDirectEngine(
        prompt: String,
        width: Int,
        height: Int,
        seed: Int
    ) async throws -> UIImage {
        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid prompt encoding"])
        }

        let urlString = "https://image.pollinations.ai/prompt/\(encodedPrompt)?width=\(width)&height=\(height)&seed=\(seed)&nologo=true"

        guard let url = URL(string: urlString) else {
            throw NSError(domain: "AIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL created"])
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.setValue("StealHexVN/3.0 (iPhone; VanKhoa)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "AIService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server response error"])
        }

        guard let uiImage = UIImage(data: data) else {
            throw NSError(domain: "AIService", code: 422, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
        }

        return uiImage
    }
}
