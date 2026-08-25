//
//  TimeCardEntry.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation

struct TimeCardEntry: Identifiable {
    var id: UUID = UUID()
    var startDate: Date
    var endDate: Date
    
    var hours: Double {
        Double(endDate.timeIntervalSince(startDate)) / 3600
    }
    
    /// The primary date for this entry (uses the start date)
    var date: Date {
        startDate
    }
    
    static let example: TimeCardEntry = {
        let now = Date()
        return TimeCardEntry(
            startDate: now,
            endDate: now.addingTimeInterval(3600)
        )
    }()
}
