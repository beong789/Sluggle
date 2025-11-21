//
//  AuthService.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createUser(email: String, password: String, displayName: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = User(
            id: result.user.uid,
            email: email,
            displayName: displayName,
            createdAt: Date()
        )
        try db.collection("users").document(user.id).setData(from: user)
        return user
    }
    
    func signIn(email: String, password: String) async throws -> String {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user.uid
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func fetchUser(uid: String) async throws -> User {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    var currentUserID: String? {
        auth.currentUser?.uid
    }
}
