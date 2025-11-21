//
//  SluggleApp.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI
import FirebaseCore

@main
struct SluggleApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
