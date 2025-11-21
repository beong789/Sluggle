//
//  Users.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let displayName: String
    let createdAt: Date
    var profileImageURL: String?
    
    var isUCSCStudent: Bool {
        email.hasSuffix("@ucsc.edu")
    }
}
