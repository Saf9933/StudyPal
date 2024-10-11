//
//  SignUpView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var showLoading = false
    @State private var animateOwl = false
    @State private var owlRotation = false

    var body: some View {
        ZStack {
            Color.lightGrayBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()

                Image("owl")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(owlRotation ? 10 : -10))
                    .offset(y: animateOwl ? -20 : 0)
                    .scaleEffect(animateOwl ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateOwl)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: owlRotation)
                    .onAppear {
                        animateOwl.toggle()
                        owlRotation.toggle()
                    }
                
                Text("Welcome to StudyPal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pastelPurple)
                    .padding(.bottom, 20)
                    .scaleEffect(showLoading ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: showLoading)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Button(action: {
                    withAnimation {
                        showLoading = true
                        signUp()
                    }
                }) {
                    HStack {
                        if showLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.trailing, 5)
                        }
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pastelPurple)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .shadow(radius: 10)
                
                Spacer()
                
                Text("Already have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                NavigationLink(destination: SignInView(isAuthenticated: $isAuthenticated)) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.bottom, 20)
            }
            .padding(.top, 50)
        }
        .navigationTitle("")
    }
    
    func signUp() {
        guard password == confirmPassword else {
            withAnimation {
                errorMessage = "Passwords do not match."
                showLoading = false
            }
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            withAnimation {
                showLoading = false
            }
            if let error = error {
                withAnimation {
                    errorMessage = error.localizedDescription
                }
            } else {
                // Optionally force token refresh
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { token, error in
                    if let error = error {
                        print("Error refreshing token: \(error.localizedDescription)")
                    } else {
                        print("Refreshed token: \(String(describing: token))")
                    }
                }
                withAnimation {
                    isAuthenticated = true
                }
            }
        }
    }
}

#Preview {
    SignUpView(isAuthenticated: .constant(false))
}
