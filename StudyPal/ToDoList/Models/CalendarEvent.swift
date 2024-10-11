//
//  CalendarEvent.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import Foundation

struct CalendarEvent: Identifiable {
    var id: String?
    var title: String
    var details: String
    var startTime: Date
    var endTime: Date
    var color: String
    var participants: [String]
}
