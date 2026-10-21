//
//  PromptClassifier.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import Foundation

struct ClassificationResult {
    let model: AIModelType
    let reasonVI: String
    let reasonEN: String
    let confidence: Double
}

enum PromptClassifier {
    static func classify(prompt: String) -> ClassificationResult {
        let text = prompt.lowercased()

        // 1. ANIME / MANGA SIGNALS
        let animeKeywords = [
            "anime", "manga", "waifu", "chibi", "otaku", "cosplay", "shonen", "shoujo",
            "webtoon", "comic", "manhwa", "kawaii", "cel shading", "studio ghibli",
            "makoto shinkai", "kyoto animation", "genshin", "naruto", "one piece",
            "dragon ball", "jujutsu", "demon slayer", "vocaloid", "hatsune miku",
            "hoat hinh", "hoạt hình", "truyen tranh", "truyện tranh", "net ve anime",
            "nét vẽ anime", "phong cach anime", "phong cách anime", "co gai anime",
            "cô gái anime", "nhan vat anime", "nhân vật anime", "phim hoat hinh", "phim hoạt hình"
        ]

        // 2. PHOTOREALISM / CINEMATIC / CAMERA SIGNALS
        let realismKeywords = [
            "photo", "photorealistic", "photography", "portrait", "dslr", "cinematic",
            "hyperrealistic", "raw photo", "skin texture", "bokeh", "depth of field",
            "candid", "canon", "nikon", "sony a7", "35mm", "50mm", "85mm", "film grain",
            "national geographic", "studio lighting", "natural lighting", "golden hour",
            "chup anh", "chụp ảnh", "anh chup", "ảnh chụp", "chan dung", "chân dung",
            "chan thuc", "chân thực", "anh that", "ảnh thật", "dien anh", "điện ảnh",
            "nhiếp ảnh", "nhiep anh", "may anh", "máy ảnh", "ro net", "rõ nét",
            "chi tiet da", "chi tiết da", "doi thuong", "đời thường", "nguoi that", "người thật"
        ]

        // 3. 3D RENDER / CGI / GAME ENGINE SIGNALS
        let render3DKeywords = [
            "3d", "3d render", "cgi", "blender", "unreal engine", "octane render",
            "pixar", "disney 3d", "isometric", "claymation", "figurine", "cinema 4d",
            "c4d", "ray tracing", "low poly", "zbrush", "character model", "3d model",
            "toy model", "funko", "do hoa 3d", "đồ họa 3d", "hoat hinh 3d", "hoạt hình 3d",
            "tuong 3d", "tượng 3d", "mo hinh 3d", "mô hình 3d", "dat set", "đất sét",
            "phong cach pixar", "phong cách pixar", "nhan vat 3d", "nhân vật 3d"
        ]

        // 4. MINIMALIST / LOGO / VECTOR SIGNALS
        let minimalistKeywords = [
            "logo", "icon", "vector", "minimalist", "minimalism", "flat design",
            "line art", "outline", "silhouette", "sticker", "badge", "emblem",
            "monogram", "clipart", "simple sketch", "black and white drawing", "stencil",
            "bieu tuong", "biểu tượng", "thiet ke logo", "thiết kế logo", "thiet ke phang",
            "thiết kế phẳng", "don sac", "đơn sắc", "nhan dan", "nhãn dán", "phac thao",
            "phác thảo", "hinh hoa", "hình họa", "net ve don gian", "nét vẽ đơn giản"
        ]

        var animeScore = 0
        for kw in animeKeywords where text.contains(kw) {
            animeScore += (kw.count > 5 ? 3 : 2)
        }

        var realismScore = 0
        for kw in realismKeywords where text.contains(kw) {
            realismScore += (kw.count > 5 ? 3 : 2)
        }

        var render3DScore = 0
        for kw in render3DKeywords where text.contains(kw) {
            render3DScore += (kw.count > 4 ? 3 : 2)
        }

        var minimalistScore = 0
        for kw in minimalistKeywords where text.contains(kw) {
            minimalistScore += (kw.count > 4 ? 3 : 2)
        }

        let maxScore = max(animeScore, realismScore, render3DScore, minimalistScore)

        if maxScore == 0 {
            // General / Artistic / High-complexity scene -> Flagship FLUX.1 Schnell
            return ClassificationResult(
                model: .fluxSchnell,
                reasonVI: "Định tuyến tự động: Nghệ thuật cao cấp (FLUX.1 Schnell)",
                reasonEN: "Auto-routed: Flagship Art Engine (FLUX.1 Schnell)",
                confidence: 0.95
            )
        }

        if animeScore == maxScore {
            return ClassificationResult(
                model: .fluxAnime,
                reasonVI: "Định tuyến tự động: Hoạt hình Anime (FLUX Anime)",
                reasonEN: "Auto-routed: Anime & Manga Engine (FLUX Anime)",
                confidence: Double(min(10, animeScore)) / 10.0
            )
        }

        if realismScore == maxScore {
            return ClassificationResult(
                model: .fluxRealism,
                reasonVI: "Định tuyến tự động: Chụp ảnh chân thực (FLUX.1 Realism)",
                reasonEN: "Auto-routed: Photorealism Engine (FLUX.1 Realism)",
                confidence: Double(min(10, realismScore)) / 10.0
            )
        }

        if render3DScore == maxScore {
            return ClassificationResult(
                model: .flux3D,
                reasonVI: "Định tuyến tự động: Đồ họa 3D CGI (FLUX 3D Render)",
                reasonEN: "Auto-routed: 3D CGI Engine (FLUX 3D Render)",
                confidence: Double(min(10, render3DScore)) / 10.0
            )
        }

        return ClassificationResult(
            model: .sdxlTurbo,
            reasonVI: "Định tuyến tự động: Đồ họa tối giản (SDXL Turbo)",
            reasonEN: "Auto-routed: Minimalist Graphics (SDXL Turbo)",
            confidence: Double(min(10, minimalistScore)) / 10.0
        )
    }
}
