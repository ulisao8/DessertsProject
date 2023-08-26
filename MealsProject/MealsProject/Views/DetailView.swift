//
//  DetailView.swift
//  MealsProject
//
//  Created by ulises.h on 26/08/23.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @ObservedObject var recipeFetcher: RecipeFetcher
    @Environment(\.presentationMode) private var presentationMode
    var mealId: String
    
    var body: some View {
        
        if let meal = recipeFetcher.meals.first(where: { $0.idMeal == mealId }) {
            VStack {
                
                if let mealDetail = recipeFetcher.mealsDetail.first(where: { $0.idMeal == mealId }) {
                    Text(mealDetail.strInstructions)
                        .padding()
                    
                    if let ingredients = getIngredients(from: mealDetail) {
                        Text("Ingredients")
                                                    .font(.headline)
                                                    .padding(.top)
                        List(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                        
                    }
                } else {
                    ProgressView("Loading...")
                }
                
                // MARK: Here we downloaded the images with the AsyncImage to improve the performance 
                AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                    switch phase {
                    case .empty:
                        Color.gray
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            }
            .navigationBarTitle(meal.strMeal)
            .onAppear {
                recipeFetcher.fetchDetail(id: mealId)
            }
        }
    }
   
    private func getIngredients(from mealDetail: MealDetail) -> [String]? {
        let ingredients = [mealDetail.strIngredient1, mealDetail.strIngredient2, mealDetail.strIngredient3]
        return ingredients.filter { !$0.isEmpty }
    }
}
