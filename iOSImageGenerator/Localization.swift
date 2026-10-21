//
//  Localization.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case vietnamese = "vi"
    case english = "en"

    var id: String { rawValue }
    var flag: String { self == .vietnamese ? "🇻🇳" : "🇬🇧" }
    var name: String { self == .vietnamese ? "Tiếng Việt" : "English" }
}

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var currentLanguage: AppLanguage = .vietnamese {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selected_app_language")
        }
    }

    init() {
        if let saved = UserDefaults.standard.string(forKey: "selected_app_language"),
           let lang = AppLanguage(rawValue: saved) {
            self.currentLanguage = lang
        }
    }

    func toggleLanguage() {
        currentLanguage = (currentLanguage == .vietnamese) ? .english : .vietnamese
    }

    func tr(_ vi: String, _ en: String) -> String {
        return currentLanguage == .vietnamese ? vi : en
    }
}
