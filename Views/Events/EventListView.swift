//
//  EventListView.swift
//  
//
//  Created by Jose Velazquez on 11/21/25.
//

import SwiftUI

struct EventListView: View {
    @StateObject private var eventViewModel = EventViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var selectedCategory: EventCategory?
    
    var filteredEvents: [Event] {
        var filtered = eventViewModel.events
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.filter { $0.startDate >= Date() }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(category: nil, selectedCategory: $selectedCategory, label: "All")
                        
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            CategoryButton(category: category, selectedCategory: $selectedCategory, label: category.rawValue)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                
                if eventViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredEvents.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No events found")
                            .font(.headline)
                        Text("Be the first to create an event!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(filteredEvents) { event in
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
            .navigationTitle("Events")
            .searchable(text: $searchText, prompt: "Search events")
            .refreshable {
                await eventViewModel.fetchEvents()
            }
            .task {
                await eventViewModel.fetchEvents()
            }
        }
    }
}

struct CategoryButton: View {
    let category: EventCategory?
    @Binding var selectedCategory: EventCategory?
    let label: String
    
    var isSelected: Bool {
        if category == nil {
            return selectedCategory == nil
        }
        return selectedCategory == category
    }
    
    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            HStack(spacing: 5) {
                if let cat = category {
                    Image(systemName: cat.icon)
                }
                Text(label)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: event.category.icon)
                    .foregroundColor(.blue)
                Text(event.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                if event.isFull {
                    Text("FULL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            
            Text(event.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(event.location, systemImage: "mappin.circle.fill")
                Spacer()
                Label("\(event.attendeeCount)", systemImage: "person.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Text(event.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
