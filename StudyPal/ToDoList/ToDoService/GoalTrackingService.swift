//
//  GoalTrackingService.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import Foundation
import Combine

class GoalTrackingService: ObservableObject {
    @Published var goals: [Goal] = []
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func removeGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
}
