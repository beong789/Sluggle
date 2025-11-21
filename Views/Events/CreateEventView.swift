//
//  CreateEventView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct CreateEventView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var eventViewModel = EventViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var selectedCategory: EventCategory = .social
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var hasMaxAttendees = false
    @State private var maxAttendees = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Title", text: $title)
                    
                    TextField("Location", text: $location)
                        .textContentType(.location)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Date & Time")) {
                    DatePicker("Start Date", selection: $startDate, in: Date()...)
                    DatePicker("End Date", selection: $endDate, in: startDate...)
                }
                
                Section(header: Text("Attendees")) {
                    Toggle("Limit attendees", isOn: $hasMaxAttendees)
                    
                    if hasMaxAttendees {
                        TextField("Max Attendees", text: $maxAttendees)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section {
                    Button(action: {
                        createEvent()
                    }) {
                        Text("Create Event")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.large)
            .alert("Event Created!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    clearForm()
                }
            } message: {
                Text("Your event has been successfully created!")
            }
        }
    }
    
    var isFormValid: Bool {
        !title.isEmpty &&
        !description.isEmpty &&
        !location.isEmpty &&
        startDate < endDate &&
        (!hasMaxAttendees || (Int(maxAttendees) ?? 0) > 0)
    }
    
    func createEvent() {
        guard let user = authViewModel.currentUser else { return }
        
        let maxAttendeesValue: Int? = hasMaxAttendees ? Int(maxAttendees) : nil
        
        Task {
            await eventViewModel.createEvent(
                title: title,
                description: description,
                category: selectedCategory,
                location: location,
                startDate: startDate,
                endDate: endDate,
                maxAttendees: maxAttendeesValue,
                creatorID: user.id,
                creatorName: user.displayName
            )
            showSuccessAlert = true
        }
    }
    
    func clearForm() {
        title = ""
        description = ""
        location = ""
        selectedCategory = .social
        startDate = Date()
        endDate = Date()
        hasMaxAttendees = false
        maxAttendees = ""
    }
}
