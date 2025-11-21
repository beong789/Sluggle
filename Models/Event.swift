//
//  Event.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let category: EventCategory
    let location: String
    let startDate: Date
    let endDate: Date
    let creatorID: String
    let creatorName: String
    var attendeeIDs: [String]
    let maxAttendees: Int?
    let createdAt: Date
    var imageURL: String?
    
    var attendeeCount: Int {
        attendeeIDs.count
    }
    
    var isFull: Bool {
        if let max = maxAttendees {
            return attendeeIDs.count >= max
        }
        return false
    }
}
