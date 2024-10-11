//
//  CalendarView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var calendarService = CalendarService()
    @State private var selectedDate = Date()
    @State private var isPresentingAddEvent = false
    @State private var isNavigatingToGoalTracking = false
    
    let pastelColors: [String: Color] = [
        "PastelRed": Color(.sRGB, red: 1.0, green: 0.6, blue: 0.6, opacity: 1),
        "PastelOrange": Color(.sRGB, red: 1.0, green: 0.8, blue: 0.6, opacity: 1),
        "PastelYellow": Color(.sRGB, red: 1.0, green: 1.0, blue: 0.6, opacity: 1),
        "PastelGreen": Color(.sRGB, red: 0.6, green: 1.0, blue: 0.6, opacity: 1),
        "PastelBlue": Color(.sRGB, red: 0.6, green: 0.8, blue: 1.0, opacity: 1),
        "PastelPurple": Color(.sRGB, red: 0.8, green: 0.6, blue: 1.0, opacity: 1)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // Custom Calendar Header
                Text(selectedDate, style: .date)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(pastelColors["PastelPurple"])
                    .padding(.top, 20)
                
                // Calendar DatePicker
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(pastelColors["PastelPurple"])
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                
                // Events List
                VStack(spacing: 20) {
                    if calendarService.getEvents(for: selectedDate).isEmpty {
                        Text("No events for today")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(calendarService.getEvents(for: selectedDate)) { event in
                            CalendarEventRow(event: event, pastelColors: pastelColors)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Button to navigate to Goal Tracking View
                Button(action: {
                    isNavigatingToGoalTracking = true
                }) {
                    Text("Track Goals")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding()
                        .background(pastelColors["PastelPurple"])
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)

                // NavigationLink for GoalTrackingView
                NavigationLink(
                    destination: GoalTrackingView(),
                    isActive: $isNavigatingToGoalTracking,
                    label: {
                        EmptyView()
                    }
                )
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isPresentingAddEvent) {
            AddEventView(calendarService: calendarService, selectedDate: $selectedDate)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresentingAddEvent.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)
                            .padding()
                            .background(pastelColors["PastelPurple"]) // Pastel purple color for visibility
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
            }
        }
    }
}

struct CalendarEventRow: View {
    var event: CalendarEvent
    var pastelColors: [String: Color]
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                Text(event.details)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                Text("\(formattedTime(event.startTime)) - \(formattedTime(event.endTime))")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                
                HStack(spacing: 4) {
                    ForEach(event.participants, id: \.self) { participant in
                        Text(participant)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(pastelColors[event.color] ?? Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .padding()
        .background(pastelColors[event.color]?.opacity(0.2) ?? Color.gray.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
