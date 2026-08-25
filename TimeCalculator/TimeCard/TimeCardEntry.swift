//
//  TimeCardEntry.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation

struct TimeCardEntry: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var startTime: Date
    var endTime: Date
    var hours: Double {
        Double(endTime.timeIntervalSince(startTime)) / 3600
    }
    
    static var example = TimeCardEntry(
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600)
    )
}
