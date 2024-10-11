//
//  SignInView.swift
//  StudyPal
//
//  Created by salma filali on 2024-08-18.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var showLoading = false
    @State private var animateOwl = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGrayBackground.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()

                    Image("owl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(y: animateOwl ? -10 : 0)
                        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateOwl)
                        .onAppear {
                            animateOwl.toggle()
                        }

                    Text("Welcome Back!")
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
                    
                    SecureField("Password", text: $password)
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
                            signIn()
                        }
                    }) {
                        HStack {
                            if showLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 5)
                            }
                            Text("Sign In")
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
                    
                    NavigationLink(destination: SignUpView(isAuthenticated: $isAuthenticated)) {
                        Text("Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                            .underline()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            .navigationTitle("")
            .onAppear {
                checkAuthentication()
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            withAnimation {
                showLoading = false
            }
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                // Optionally force token refresh
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { token, error in
                    if let error = error {
                        print("Error refreshing token: \(error.localizedDescription)")
                    } else {
                        print("Refreshed token: \(String(describing: token))")
                    }
                }
                self.isAuthenticated = true
            }
        }
    }
    
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        }
    }
}

#Preview {
    SignInView(isAuthenticated: .constant(false))
}
