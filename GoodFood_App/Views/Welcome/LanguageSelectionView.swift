//
//  LanguageSelectionView.swift
//  AppleStore
//
//  Created by Guest User on 22/8/25.
//

// .background(isSelected ? Color.green.opacity(0.15) : Color.white)
import SwiftUI

struct LanguageSelectionView: View {
//    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) var dismiss
    @State private var isSelected: Bool = false
   
   let languages = [
        Language(code: "en", name: "English", englishName: "English", flag: "🇬🇧" , codeDate: "en_US"),
        Language(code: "vi", name: "Tiếng Việt", englishName: "Vietnamese", flag: "🇻🇳" ,codeDate: "en_US"),
        Language(code: "zh", name: "简体中文", englishName: "Chinese (Simplified)", flag: "🇨🇳",codeDate: "en_US"),
        Language(code: "ja", name: "日本語", englishName: "Japanese", flag: "🇯🇵",codeDate: "ja_JP"),
        Language(code: "ko", name: "한국어", englishName: "Korean", flag: "🇰🇷",codeDate: "ko_KR"),
        Language(code: "fr", name: "Français", englishName: "French", flag: "🇫🇷",codeDate: "fr_FR1    "),
        Language(code: "de", name: "Deutsch", englishName: "German", flag: "🇩🇪",codeDate: "de_DE"),
        Language(code: "es", name: "Español", englishName: "Spanish", flag: "🇪🇸",codeDate: "es_ES"),
        Language(code: "pt", name: "Português", englishName: "Portuguese", flag: "🇵🇹",codeDate: "pt_PT"),
        Language(code: "ru", name: "Русский", englishName: "Russian", flag: "🇷🇺",codeDate: "ru_RU"),
        Language(code: "ar", name: "العربية", englishName: "Arabic", flag: "🇸🇦",codeDate: "ar_SA"),
        Language(code: "hi", name: "हिन्दी", englishName: "Hindi", flag: "🇮🇳",codeDate: "hi_IN"),
        Language(code: "id", name: "Bahasa Indonesia", englishName: "Indonesian", flag: "🇮🇩",codeDate: "id_ID"),
        Language(code: "ms", name: "Bahasa Melayu", englishName: "Malay", flag: "🇲🇾",codeDate: "ms_MY"),
        Language(code: "th", name: "ไทย", englishName: "Thai", flag: "🇹🇭",codeDate: "th_TH")
    ]
    
    var body: some View {
        VStack {
            ZStack {
                Text(languageManager.localizedString("Languages"))
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 50)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Spacer()
                    Button(action: {
                        print("Đã chọn ngôn ngữ ")
                        isSelected = true
                        dismiss()
                    }
                    ){
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .font(.title2)
                            .padding(.top, 30)
                            .padding(.trailing, 16)
                    }
                }
            }

            ScrollView {
                VStack(spacing: 12) {
                                ForEach(languages, id: \.code) { language in
                                    CardLanguage(
                                        language: language,
                                        isSelected: .constant(languageManager.selectedLanguage == language.code)
                                    )
                                    .onTapGesture {
                                        languageManager.selectedLanguage = language.code
                                        print("Ngôn ngữ vừa được chọn:\(language.code) - \(language.name)")
                                    }
                                }
                            }
                .padding()
            }
        }
    }
}

struct CardLanguage: View {
    @EnvironmentObject var languageManager: LanguageManager
    var language: Language
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Text(languageManager.localizedString(language.flag))
                .font(.system(size: 40))
               
            VStack(alignment: .leading, spacing: 4) {
                if isSelected {
                    Text(languageManager.localizedString(language.name))
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text(languageManager.localizedString("selected language"))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                else {
                    Text(languageManager.localizedString(language.name))
                        .font(.headline)
                        
                    Text(languageManager.localizedString(language.englishName))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
//
//#Preview {
//    NavigationStack {
//        LanguageSelectionView()
//    }
//}
