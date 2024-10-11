//
//  AddEventView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var calendarService: CalendarService
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventTitle = ""
    @State private var eventDetails = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600) // Default to 1 hour later
    @State private var selectedColor = "PastelBlue"
    @State private var participants = [String]()
    @State private var newParticipant = ""
    
    let colors: [String] = ["PastelBlue", "PastelYellow", "PastelPink"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Title")) {
                    TextField("Enter title", text: $eventTitle)
                }
                
                Section(header: Text("Event Details")) {
                    TextField("Enter details", text: $eventDetails)
                }
                
                Section(header: Text("Time")) {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Participants")) {
                    HStack {
                        TextField("Add participant", text: $newParticipant)
                        Button(action: {
                            if !newParticipant.isEmpty {
                                participants.append(newParticipant)
                                newParticipant = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    ForEach(participants, id: \.self) { participant in
                        Text(participant)
                    }
                }
                
                Section(header: Text("Color")) {
                    Picker("Select Color", selection: $selectedColor) {
                        ForEach(colors, id: \.self) { color in
                            Text(color)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Add New Event", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newEvent = CalendarEvent(
                    title: eventTitle,
                    details: eventDetails,
                    startTime: startTime,
                    endTime: endTime,
                    color: selectedColor,
                    participants: participants
                )
                calendarService.addEvent(newEvent)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
