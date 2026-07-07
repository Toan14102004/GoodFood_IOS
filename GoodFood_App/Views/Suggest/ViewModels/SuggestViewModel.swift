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
