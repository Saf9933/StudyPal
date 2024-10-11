//
//  CategoryCard.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import SwiftUI

struct CategoryCard: View {
    var title: String
    var taskCount: Int
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(taskCount) Tasks")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 150, height: 100)
        .background(color)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
