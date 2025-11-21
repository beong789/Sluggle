//
//  EventViewModel.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation

@MainActor
class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var userEvents: [Event] = []
    @Published var createdEvents: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let eventService = EventService.shared
    
    func fetchEvents() async {
        isLoading = true
        do {
            events = try await eventService.fetchEvents()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func createEvent(title: String, description: String, category: EventCategory, location: String, startDate: Date, endDate: Date, maxAttendees: Int?, creatorID: String, creatorName: String) async {
        let event = Event(
            title: title,
            description: description,
            category: category,
            location: location,
            startDate: startDate,
            endDate: endDate,
            creatorID: creatorID,
            creatorName: creatorName,
            attendeeIDs: [creatorID],
            maxAttendees: maxAttendees,
            createdAt: Date()
        )
        
        do {
            try await eventService.createEvent(event)
            await fetchEvents()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func joinEvent(_ event: Event, userID: String) async {
        guard let eventID = event.id else { return }
        do {
            try await eventService.joinEvent(eventID: eventID, userID: userID)
            await fetchEvents()
            await fetchUserEvents(userID: userID)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func leaveEvent(_ event: Event, userID: String) async {
        guard let eventID = event.id else { return }
        do {
            try await eventService.leaveEvent(eventID: eventID, userID: userID)
            await fetchEvents()
            await fetchUserEvents(userID: userID)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteEvent(_ event: Event) async {
        guard let eventID = event.id else { return }
        do {
            try await eventService.deleteEvent(id: eventID)
            await fetchEvents()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchUserEvents(userID: String) async {
        do {
            userEvents = try await eventService.fetchUserEvents(userID: userID)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchCreatedEvents(userID: String) async {
        do {
            createdEvents = try await eventService.fetchCreatedEvents(userID: userID)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
