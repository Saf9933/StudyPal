//
//  StudyPalApp.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct StudyPalApp: App {
    @State private var isAuthenticated = false

    init() {
        FirebaseApp.configure()
        checkUserAuthentication()
    }

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView(isAuthenticated: $isAuthenticated)
            } else {
                SignInView(isAuthenticated: $isAuthenticated)
            }
        }
    }

    func checkUserAuthentication() {
        isAuthenticated = Auth.auth().currentUser != nil
    }
}

