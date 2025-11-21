//
//  EventDetailView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var eventViewModel = EventViewModel()
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss
    
    var isCreator: Bool {
        event.creatorID == authViewModel.currentUser?.id
    }
    
    var isAttending: Bool {
        guard let userID = authViewModel.currentUser?.id else { return false }
        return event.attendeeIDs.contains(userID)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: event.category.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(event.category.rawValue)
                        .font(.headline)
                        .foregroundColor(.blue)
                    Spacer()
                }
                
                Text(event.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(icon: "person.fill", text: "Created by \(event.creatorName)")
                    DetailRow(icon: "calendar", text: event.formattedDate)
                    DetailRow(icon: "mappin.circle.fill", text: event.location)
                    DetailRow(icon: "person.2.fill", text: "\(event.attendeeCount) attending" + (event.maxAttendees != nil ? " / \(event.maxAttendees!)" : ""))
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(event.description)
                        .foregroundColor(.secondary)
                }
                
                if !isCreator {
                    Button(action: {
                        guard let userID = authViewModel.currentUser?.id else { return }
                        Task {
                            if isAttending {
                                await eventViewModel.leaveEvent(event, userID: userID)
                            } else {
                                await eventViewModel.joinEvent(event, userID: userID)
                            }
                            dismiss()
                        }
                    }) {
                        Text(isAttending ? "Leave Event" : "Join Event")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isAttending ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(event.isFull && !isAttending)
                }
                
                if isCreator {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete Event")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await eventViewModel.deleteEvent(event)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this event? This action cannot be undone.")
        }
    }
}

struct DetailRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}
