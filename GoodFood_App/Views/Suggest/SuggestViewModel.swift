//
//  SuggestViewModel.swift
//  GoodFood_App
//
//  Created by Guest User on 14/7/25.
//

import Foundation

class SuggestViewModel: ObservableObject {
    @Published var dishes: [Dish] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var hasFetched = false

//    func fetchSuggestions() {
//        
//        guard !hasFetched else { return } // ❌ Không gọi lại nếu đã gọi rồi
//                hasFetched = true
//        
//        isLoading = true
//        errorMessage = nil
//
//        FirebaseService().fetchTargetWeight { result1 in
//            switch result1 {
//            case .success(let targetStr):
//                FirebaseService().fetchCurrentWeight { result2 in
//                    switch result2 {
//                    case .success(let currentStr):
//                        print(" Target: \(targetStr),  Current: \(currentStr)")
//
//                        GeminiService.shared.Suggestion(text1: targetStr, text2: currentStr) { result in
//                            DispatchQueue.main.async {
//                                self.isLoading = false
//                                switch result {
//                                case .success(let dishSuggestions):
//                                    self.dishes = dishSuggestions.map { suggestion in
//                                        Dish(
//                                            id: UUID(),
//                                            name: suggestion.name,
//                                            description: suggestion.description,
//                                            image: nil,
//                                            recipe: suggestion.recipe,
//                                            ingredients: suggestion.ingredients,
//                                            nutritionFacts: suggestion.nutritionFacts
//                                        )
//                                    }
//                                case .failure(let error):
//                                    self.errorMessage = error.localizedDescription
//                                }
//                            }
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            self.isLoading = false
//                            self.errorMessage = "Lỗi lấy cân nặng hiện tại: \(error.localizedDescription)"
//                        }
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.errorMessage = "Lỗi lấy cân nặng mục tiêu: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
    func fetchSuggestions() {
        guard !hasFetched else { return }
        hasFetched = true
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let target = try await FirebaseService().fetchTargetWeight()
                let current = try await FirebaseService().fetchCurrentWeight()
                print("Target: \(target), Current: \(current)")

                let result = try await GeminiService.shared.suggestionAsync(text1: target, text2: current)

                DispatchQueue.main.async {
                    self.dishes = result.map { suggestion in
                        Dish(
                            id: UUID(),
                            name: suggestion.name,
                            description: suggestion.description,
                            image: nil,
                            recipe: suggestion.recipe,
                            ingredients: suggestion.ingredients,
                            nutritionFacts: suggestion.nutritionFacts
                        )
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Lỗi: \(error.localizedDescription)"
                }
            }
        }
    }

}
