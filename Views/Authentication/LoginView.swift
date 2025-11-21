//
//  LoginView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Sluggle")
                    .font(.largeTitle)
                    .bold()
                
                Text("Connect with UCSC Students")
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    TextField("UCSC Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            await authViewModel.signIn(email: email, password: password)
                        }
                    }) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button("Don't have an account? Sign Up") {
                        showSignUp = true
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .padding()
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}
