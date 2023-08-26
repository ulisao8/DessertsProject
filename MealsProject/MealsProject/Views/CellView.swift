//
//  CellView.swift
//  MealsProject
//
//  Created by ulises.h on 26/08/23.
//

import Foundation
import SwiftUI

struct CellView: View {
    var meal: Meal
    
    var body: some View {
        HStack {
            // MARK: Here we downloaded the images with the AsyncImage to improve the performance and  validate empty states to set a default image
            
            AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                @unknown default:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            
            Text(meal.strMeal)
                .font(.headline)
                .padding(.leading, 10)
            
            Spacer()
        }
        .padding(10)
        .background(Color.white)
    }
    
}
