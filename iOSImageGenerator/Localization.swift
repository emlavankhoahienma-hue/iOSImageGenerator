//
//  Localization.swift
//  iOSImageGenerator
//
//  Tác giả / Author: VanKhoa
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case vietnamese = "vi"
    case english = "en"

    var id: String { rawValue }
    var flag: String { self == .vietnamese ? "🇻🇳" : "🇬🇧" }
    var name: String { self == .vietnamese ? "Tiếng Việt" : "English" }
}

final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @AppStorage("selected_app_language") var currentLanguage: AppLanguage = .vietnamese

    func toggleLanguage() {
        currentLanguage = (currentLanguage == .vietnamese) ? .english : .vietnamese
    }

    func tr(_ vi: String, _ en: String) -> String {
        return currentLanguage == .vietnamese ? vi : en
    }
}
