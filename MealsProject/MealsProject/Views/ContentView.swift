//
//  ContentView.swift
//  MealsProject
//
//  Created by ulises.h on 26/08/23.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

// MARK: The view is only a List with a  recipeFetcher to handle the request data and also has a DetailView and CellView

struct ContentView: View {
    @ObservedObject var recipeFetcher = RecipeFetcher()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Desserts")
                    .font(.largeTitle)
                    .padding(.top, 16)
                
                if recipeFetcher.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(recipeFetcher.meals) { meal in
                        NavigationLink(destination: DetailView(recipeFetcher: recipeFetcher, mealId: meal.idMeal)) {
                            CellView(meal: meal)
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
        .onAppear {
            recipeFetcher.fetchMeals()
        }
    }
}

