//
//  ImageGenerator.swift
//  iOSImageGenerator
//
//  Created by Adi Mizrahi on 08/07/2025.
//  Updated by VanKhoaSWIFT
//

import Foundation
import UIKit
import ImagePlayground

enum GenerationStyle: String, CaseIterable, Identifiable {
    case illustration = "Illustration"
    case animation = "Animation"
    case sketch = "Sketch"

    var id: String { rawValue }

    var playgroundStyle: ImagePlaygroundStyle {
        switch self {
        case .illustration:
            return .illustration
        case .animation:
            return .animation
        case .sketch:
            return .sketch
        }
    }
}

enum ImageGenerator {
    static func generate(from prompt: String, style: ImagePlaygroundStyle = .illustration) async throws -> UIImage? {
        let creator = try await ImageCreator()
        let results = creator.images(for: [.text(prompt)], style: style, limit: 1)

        for try await result in results {
            return UIImage(cgImage: result.cgImage)
        }

        return nil
    }
}
