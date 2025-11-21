//
//  MainTabView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            EventListView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            CreateEventView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
