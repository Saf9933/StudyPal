//
//  Goal.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//
import Foundation

class Goal: ObservableObject, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var color: String
    @Published var progress: Float
    
    init(title: String, description: String, color: String, progress: Float) {
        self.title = title
        self.description = description
        self.color = color
        self.progress = progress
    }
}
