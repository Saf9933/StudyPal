//
//  Task.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import Foundation

struct Task: Identifiable {
    var id: String?
    var title: String
    var description: String?
    var priority: String
    var dueDate: Date
    var completed: Bool
    var iconName: String? // New property to store the icon name

    init(id: String? = nil, title: String, description: String? = nil, priority: String, dueDate: Date, completed: Bool = false, iconName: String? = "pencil.circle.fill") {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.dueDate = dueDate
        self.completed = completed
        self.iconName = iconName
    }
}
