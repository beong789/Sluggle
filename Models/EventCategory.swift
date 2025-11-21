//
//  EventCategory.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import Foundation

enum EventCategory: String, Codable, CaseIterable {
    case sports = "Sports"
    case study = "Study"
    case social = "Social"
    case food = "Food"
    case outdoor = "Outdoor"
    case gaming = "Gaming"
    case arts = "Arts & Culture"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .sports: return "figure.run"
        case .study: return "book.fill"
        case .social: return "person.3.fill"
        case .food: return "fork.knife"
        case .outdoor: return "mountain.2.fill"
        case .gaming: return "gamecontroller.fill"
        case .arts: return "paintpalette.fill"
        case .other: return "star.fill"
        }
    }
}
