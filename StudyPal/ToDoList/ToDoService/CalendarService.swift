//
//  CalendarService.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import Foundation

class CalendarService: ObservableObject {
    @Published private(set) var events: [CalendarEvent] = []
    
    func addEvent(_ event: CalendarEvent) {
        events.append(event)
    }
    
    func getEvents(for date: Date) -> [CalendarEvent] {
        return events.filter { Calendar.current.isDate($0.startTime, inSameDayAs: date) }
    }
    
    func updateEvent(_ event: CalendarEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        }
    }
    
    func deleteEvent(_ event: CalendarEvent) {
        events.removeAll { $0.id == event.id }
    }
}
