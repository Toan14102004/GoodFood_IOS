import Foundation
import SwiftUI

struct Language: Identifiable, Codable {
    let id = UUID()
    let code: String
    let name: String
    let englishName: String
    let flag: String
    let codeDate: String
    
}

class LanguageViewModel: ObservableObject {
    @Published var languages: [Language] = [
        Language(code: "en", name: "English", englishName: "English", flag: "🇬🇧" , codeDate: "en_US"),
        Language(code: "vi", name: "Tiếng Việt", englishName: "Vietnamese", flag: "🇻🇳" ,codeDate: "en_US"),
        Language(code: "zh", name: "简体中文", englishName: "Chinese (Simplified)", flag: "🇨🇳",codeDate: "en_US"),
        Language(code: "ja", name: "日本語", englishName: "Japanese", flag: "🇯🇵",codeDate: "en_US"),
        Language(code: "ko", name: "한국어", englishName: "Korean", flag: "🇰🇷",codeDate: "en_US"),
        Language(code: "fr", name: "Français", englishName: "French", flag: "🇫🇷",codeDate: "en_US"),
        Language(code: "de", name: "Deutsch", englishName: "German", flag: "🇩🇪",codeDate: "en_US"),
        Language(code: "es", name: "Español", englishName: "Spanish", flag: "🇪🇸",codeDate: "en_US"),
        Language(code: "pt", name: "Português", englishName: "Portuguese", flag: "🇵🇹",codeDate: "en_US"),
        Language(code: "ru", name: "Русский", englishName: "Russian", flag: "🇷🇺",codeDate: "en_US"),
        Language(code: "ar", name: "العربية", englishName: "Arabic", flag: "🇸🇦",codeDate: "en_US"),
        Language(code: "hi", name: "हिन्दी", englishName: "Hindi", flag: "🇮🇳",codeDate: "en_US"),
        Language(code: "id", name: "Bahasa Indonesia", englishName: "Indonesian", flag: "🇮🇩",codeDate: "en_US"),
        Language(code: "ms", name: "Bahasa Melayu", englishName: "Malay", flag: "🇲🇾",codeDate: "en_US"),
        Language(code: "th", name: "ไทย", englishName: "Thai", flag: "🇹🇭",codeDate: "en_US")
    ]
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            bundle = LanguageManager.loadBundle(for: selectedLanguage)
        }
    }
    
    @Published var date: String = ""

    @Published var bundle: Bundle

    init() {
        let saved = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        self.selectedLanguage = saved
//        self.date = Us
        self.bundle = LanguageManager.loadBundle(for: saved)
    }

    static func loadBundle(for language: String) -> Bundle {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path)
        {
            return bundle
        }
        return .main // fallback
    }

    func localizedString(_ key: String) -> String {
        NSLocalizedString(key, bundle: bundle, comment: "")
    }
//    func reloadDate(_ key: String) -> String {
//        
//    }
}
