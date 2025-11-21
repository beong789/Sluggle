//
//  ProfileView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var eventViewModel = EventViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let user = authViewModel.currentUser {
                    VStack(spacing: 15) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text(user.displayName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            Text("Sign Out")
                                .foregroundColor(.red)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    
                    Picker("", selection: $selectedTab) {
                        Text("Attending").tag(0)
                        Text("Created").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if selectedTab == 0 {
                        if eventViewModel.userEvents.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("No events yet")
                                    .font(.headline)
                                Text("Join events to see them here")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 15) {
                                    ForEach(eventViewModel.userEvents) { event in
                                        NavigationLink(destination: EventDetailView(event: event)) {
                                            EventCard(event: event)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding()
                            }
                        }
                    } else {
                        if eventViewModel.createdEvents.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                Text("No events created")
                                    .font(.headline)
                                Text("Create your first event")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 15) {
                                    ForEach(eventViewModel.createdEvents) { event in
                                        NavigationLink(destination: EventDetailView(event: event)) {
                                            EventCard(event: event)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                if let userID = authViewModel.currentUser?.id {
                    await eventViewModel.fetchUserEvents(userID: userID)
                    await eventViewModel.fetchCreatedEvents(userID: userID)
                }
            }
        }
    }
}
