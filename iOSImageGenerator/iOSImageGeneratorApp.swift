//
//  iOSImageGeneratorApp.swift
//  iOSImageGenerator
//
//  Created by Adi Mizrahi on 08/07/2025.
//  Updated by VanKhoaSWIFT
//

import SwiftUI

@main
struct iOSImageGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 18.4, *) {
                PromptImageView()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.applewatch")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("iOS 18.4+ Required")
                        .font(.headline)
                    Text("Apple Intelligence ImagePlayground requires iOS 18.4 or newer.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
}
