//
//  ImageGenerator.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import Foundation
import UIKit

#if canImport(ImagePlayground)
import ImagePlayground

@available(iOS 18.4, *)
enum AppleIntelligenceBridge {
    static func generate(from prompt: String, style: ImagePlaygroundStyle = .illustration) async throws -> UIImage? {
        let creator = try await ImageCreator()
        let results = creator.images(for: [.text(prompt)], style: style, limit: 1)

        for try await result in results {
            return UIImage(cgImage: result.cgImage)
        }

        return nil
    }
}
#endif
