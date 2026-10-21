//
//  PromptEngine.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import Foundation

enum PromptEngine {
    // Dictionary mapping common Vietnamese concepts to high-fidelity English diffusion prompt tokens
    private static let conceptMap: [(vi: String, en: String)] = [
        // Subjects
        ("cô gái việt nam", "stunning Vietnamese young woman"),
        ("cô gái", "beautiful young woman"),
        ("chàng trai", "handsome young man"),
        ("thiếu nữ", "graceful young maiden"),
        ("người già", "elderly person with weathered expressive face"),
        ("ông cụ", "elderly Vietnamese grandfather with kind eyes"),
        ("bà cụ", "elderly Vietnamese grandmother with gentle smile"),
        ("em bé", "adorable happy little child"),
        ("mèo con", "cute fluffy kitten"),
        ("mèo phi hành gia", "adorable astronaut cat with cosmic helmet"),
        ("mèo", "adorable cat"),
        ("chó", "cute loyal dog"),
        ("rồng vàng", "magnificent imperial golden dragon with glowing scales"),
        ("rồng", "majestic oriental dragon soaring"),
        ("phượng hoàng", "resplendent fiery phoenix bird"),
        ("hổ", "majestic powerful tiger"),
        ("ngựa", "graceful wild stallion"),
        ("hoa sen", "blooming pink lotus flowers and green leaves"),
        ("hoa đào", "delicate pink cherry peach blossoms"),
        ("hoa mai", "vibrant yellow apricot blossoms"),
        ("cúc họa mi", "delicate white daisy flowers"),

        // Vietnamese culture & attire
        ("áo dài trắng", "pristine white flowing silk Ao Dai dress"),
        ("áo dài", "traditional elegant Vietnamese silk Ao Dai dress"),
        ("nón lá", "traditional Vietnamese conical leaf hat"),
        ("cổ phục", "traditional historical Vietnamese royal attire"),
        ("vịnh hạ long", "Ha Long Bay emerald waters and limestone islets"),
        ("phố cổ hội an", "Hoi An ancient town with glowing colorful lanterns"),
        ("hà nội", "Hanoi historic Old Quarter with autumn leaves"),
        ("sài gòn", "modern Ho Chi Minh City skyline at twilight"),
        ("ruộng bậc thang", "cascading Sapa green terraced rice fields"),
        ("chùa", "ancient Buddhist temple sanctuary with incense smoke"),
        ("đình", "traditional Vietnamese communal village hall"),

        // Scenery & Atmosphere
        ("hoàng hôn", "radiant golden hour sunset with warm rim light"),
        ("bình minh", "peaceful misty morning sunrise with soft rays"),
        ("trời mưa", "atmospheric rain with reflective wet pavement"),
        ("ban đêm", "dramatic cinematic night with atmospheric glow"),
        ("vũ trụ", "deep cosmic nebula with glittering galaxies and starfields"),
        ("rừng tre", "lush tranquil green bamboo grove in morning fog"),
        ("bờ biển", "pristine ocean coastline with turquoise gentle waves"),
        ("núi tuyết", "dramatic majestic snow-capped mountain peaks"),
        ("thành phố tương lai", "futuristic sci-fi metropolis with flying vehicles and glowing neon towers"),
        ("quán cà phê", "cozy warm coffee shop with steaming cups and soft ambient lights"),

        // Styles & Mediums
        ("chân dung điện ảnh", "cinematic film still, 35mm anamorphic lens, shallow depth of field"),
        ("chân dung", "professional studio portrait, 85mm f/1.4 lens, soft bokeh"),
        ("ảnh chụp", "candid professional photograph, realistic textures, natural lighting"),
        ("chân thực", "hyperrealistic photography, fine skin texture, detailed eyes"),
        ("sơn dầu", "rich textured oil painting on canvas with expressive brush strokes"),
        ("thủy mặc", "traditional East Asian ink wash painting with minimalist elegance"),
        ("tranh màu nước", "delicate watercolor painting with translucent soft washes"),
        ("hoạt hình anime", "vibrant high-end anime aesthetic, Makoto Shinkai lighting, dynamic cel shading"),
        ("anime", "masterpiece anime illustration with expressive eyes and clean linework"),
        ("mô hình 3d", "stylized 3D render, Pixar animation studio aesthetic, Blender Octane"),
        ("3d", "clean 3D CGI digital asset, ambient occlusion, smooth shading"),
        ("logo tối giản", "minimalist geometric vector logo emblem, clean flat lines"),
        ("trượt ván", "riding a futuristic skateboard in motion blur")
    ]

    static func enhancePrompt(rawPrompt: String, model: AIModelType) -> String {
        var text = rawPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return rawPrompt }

        let lower = text.lowercased()
        var translatedParts: [String] = []

        // 1. Detect and map Vietnamese concepts to rich English tokens
        for item in conceptMap {
            if lower.contains(item.vi) {
                translatedParts.append(item.en)
            }
        }

        let baseSubject: String
        if !translatedParts.isEmpty {
            baseSubject = translatedParts.joined(separator: ", ")
        } else {
            baseSubject = text
        }

        // 2. Attach tailored visual fidelity and lighting modifiers according to the target AI model
        let styleModifiers: String
        switch model {
        case .fluxRealism:
            styleModifiers = "award-winning photography, 85mm f/1.4 lens, natural skin micro-texture, subtle rim lighting, high dynamic range, sharp focus, 8k resolution, authentic raw photo"

        case .fluxAnime:
            styleModifiers = "masterpiece anime illustration, highly detailed, vibrant harmonious palette, expressive eyes, Makoto Shinkai studio aesthetic, cinematic anime lighting, 8k art"

        case .flux3D:
            styleModifiers = "stylized 3D render, Blender 3D, Pixar Disney animation quality, smooth subsurface scattering, Octane Render, warm ambient illumination, high definition 8k"

        case .sdxlTurbo:
            styleModifiers = "clean vector aesthetic, crisp lines, minimalist graphic design, high contrast, elegant flat composition, professional artwork"

        case .fluxSchnell, .appleIntelligence:
            styleModifiers = "masterpiece, intricately detailed, atmospheric lighting, beautiful composition, cinematic atmosphere, high aesthetic value, 8k resolution"
        }

        return "\(baseSubject), \(styleModifiers)"
    }
}
