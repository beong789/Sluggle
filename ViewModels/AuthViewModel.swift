//
//  AuthViewModel.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let firebaseUser = auth.currentUser {
            fetchUser(uid: firebaseUser.uid)
        }
    }
    
    func signUp(email: String, password: String, displayName: String) async {
        guard email.hasSuffix("@ucsc.edu") else {
            errorMessage = "Please use a valid @ucsc.edu email address"
            return
        }
        
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = User(
                id: result.user.uid,
                email: email,
                displayName: displayName,
                createdAt: Date()
            )
            try db.collection("users").document(user.id).setData(from: user)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            fetchUser(uid: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() {
        try? auth.signOut()
        isAuthenticated = false
        currentUser = nil
    }
    
    private func fetchUser(uid: String) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let user = try? snapshot?.data(as: User.self) {
                self.currentUser = user
                self.isAuthenticated = true
            }
        }
    }
}
