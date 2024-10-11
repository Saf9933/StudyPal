//
//  GoalTrackingView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-24.
//

import SwiftUI

struct GoalTrackingView: View {
    @ObservedObject var goalService = GoalTrackingService()
    @State private var isPresentingAddGoal = false
    
    let pastelColors: [String: Color] = [
        "PastelRed": Color(.sRGB, red: 1.0, green: 0.6, blue: 0.6, opacity: 1),
        "PastelOrange": Color(.sRGB, red: 1.0, green: 0.8, blue: 0.6, opacity: 1),
        "PastelYellow": Color(.sRGB, red: 1.0, green: 1.0, blue: 0.6, opacity: 1),
        "PastelGreen": Color(.sRGB, red: 0.6, green: 1.0, blue: 0.6, opacity: 1),
        "PastelBlue": Color(.sRGB, red: 0.6, green: 0.8, blue: 1.0, opacity: 1),
        "PastelPurple": Color(.sRGB, red: 0.8, green: 0.6, blue: 1.0, opacity: 1)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("My Goals")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(pastelColors["PastelPurple"])
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if goalService.goals.isEmpty {
                            Text("No goals set yet")
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                                .foregroundColor(.gray)
                        } else {
                            ForEach(goalService.goals) { goal in
                                GoalRow(goal: goal, pastelColors: pastelColors)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingAddGoal.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.white)
                            .padding()
                            .background(pastelColors["PastelPurple"])
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .sheet(isPresented: $isPresentingAddGoal) {
                        AddGoalView(goalService: goalService)
                    }
                }
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct GoalRow: View {
    @ObservedObject var goal: Goal
    var pastelColors: [String: Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(goal.title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
            
            Text(goal.description)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.gray)
            
            ProgressBar(value: goal.progress)
                .frame(height: 10)
                .padding(.top, 5)
                .accentColor(pastelColors[goal.color] ?? pastelColors["PastelPurple"])
            
            // Slider to manually adjust progress
            HStack {
                Text("Progress: \(Int(goal.progress * 100))%")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                
                Slider(value: $goal.progress, in: 0...1, step: 0.01)
                    .accentColor(pastelColors[goal.color] ?? pastelColors["PastelPurple"])
            }
            .padding(.top, 5)
        }
        .padding()
        .background(pastelColors[goal.color]?.opacity(0.2) ?? Color.gray.opacity(0.2))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ProgressBar: View {
    var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.blue)
                    .animation(.linear)
            }
            .cornerRadius(45.0)
        }
    }
}

struct AddGoalView: View {
    @ObservedObject var goalService: GoalTrackingService
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State private var color = "PastelPurple"
    
    var pastelColors: [String: Color] = [
        "PastelRed": Color(.sRGB, red: 1.0, green: 0.6, blue: 0.6, opacity: 1),
        "PastelOrange": Color(.sRGB, red: 1.0, green: 0.8, blue: 0.6, opacity: 1),
        "PastelYellow": Color(.sRGB, red: 1.0, green: 1.0, blue: 0.6, opacity: 1),
        "PastelGreen": Color(.sRGB, red: 0.6, green: 1.0, blue: 0.6, opacity: 1),
        "PastelBlue": Color(.sRGB, red: 0.6, green: 0.8, blue: 1.0, opacity: 1),
        "PastelPurple": Color(.sRGB, red: 0.8, green: 0.6, blue: 1.0, opacity: 1)
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    
                    Picker("Color", selection: $color) {
                        ForEach(pastelColors.keys.sorted(), id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                }
                
                Button("Save Goal") {
                    let newGoal = Goal(title: title, description: description, color: color, progress: 0.0)
                    goalService.addGoal(newGoal)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct GoalTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        let goalService = GoalTrackingService()
        goalService.addGoal(Goal(title: "Finish Project", description: "Complete the SwiftUI project by end of month", color: "PastelPurple", progress: 0.5))
        
        return GoalTrackingView(goalService: goalService)
            .previewDevice("iPhone 12")
    }
}

