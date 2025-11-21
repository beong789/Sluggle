//
//  EventService.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation
import FirebaseFirestore

class EventService {
    static let shared = EventService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createEvent(_ event: Event) async throws {
        try db.collection("events").document().setData(from: event)
    }
    
    func fetchEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events")
            .order(by: "startDate")
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Event.self) }
    }
    
    func fetchEvent(id: String) async throws -> Event {
        let snapshot = try await db.collection("events").document(id).getDocument()
        return try snapshot.data(as: Event.self)
    }
    
    func updateEvent(_ event: Event) async throws {
        guard let id = event.id else { return }
        try db.collection("events").document(id).setData(from: event)
    }
    
    func deleteEvent(id: String) async throws {
        try await db.collection("events").document(id).delete()
    }
    
    func joinEvent(eventID: String, userID: String) async throws {
        let eventRef = db.collection("events").document(eventID)
        try await eventRef.updateData([
            "attendeeIDs": FieldValue.arrayUnion([userID])
        ])
    }
    
    func leaveEvent(eventID: String, userID: String) async throws {
        let eventRef = db.collection("events").document(eventID)
        try await eventRef.updateData([
            "attendeeIDs": FieldValue.arrayRemove([userID])
        ])
    }
    
    func fetchUserEvents(userID: String) async throws -> [Event] {
        let snapshot = try await db.collection("events")
            .whereField("attendeeIDs", arrayContains: userID)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Event.self) }
    }
    
    func fetchCreatedEvents(userID: String) async throws -> [Event] {
        let snapshot = try await db.collection("events")
            .whereField("creatorID", isEqualTo: userID)
            .getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Event.self) }
    }
}
