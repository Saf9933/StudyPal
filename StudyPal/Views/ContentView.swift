//
//  ContentView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        MainTabView()
            .onAppear {
                checkAuthentication()
            }
    }

    func checkAuthentication() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ExpenseTrackerView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Calendar")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color(red: 204/255, green: 178/255, blue: 255/255)) // Light purple when selected
    }
}
