//
//  DesertsViewModel.swift
//  MealsProject
//
//  Created by ulises.h on 26/08/23.
//

import Foundation
import SwiftUI
import Combine

enum FetchError: Error {
    case timedOut
}

class RecipeFetcher: ObservableObject {
    
    // Variables Published to communicate with the viewas
    @Published var meals: [Meal] = []
    @Published var mealsDetail: [MealDetail] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var mealsDetailCache: [String: MealDetail] = [:] 
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchMeals()
    }
    
    // MARK: Call to fetch the meals or desserts, using native Sessions tasks
    func fetchMeals() {
        guard let url = URL(string: Constants.urlDesserts) else {
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Meals.self, decoder: JSONDecoder())
            .map(\.meals)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.isLoading = false
            }, receiveValue: { [weak self] meals in
                self?.meals = meals
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    // MARK: Call to fetch the details of the  desserts, using native Sessions tasks
    func fetchDetail(id: String) {
        self.errorMessage = nil
        if let cachedDetail = mealsDetailCache[id] {
            self.mealsDetail = [cachedDetail]
            return
        }
        
        guard let url = URL(string:  Constants.urlDetail + id) else {
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MealDetailResponse.self, decoder: JSONDecoder())
            .map(\.meals)
            .timeout(5, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] meals in
                if let detail = meals.first {
                    self?.mealsDetail = meals
                    self?.mealsDetailCache[id] = detail // Almacenamos en la caché
                }
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }


}
