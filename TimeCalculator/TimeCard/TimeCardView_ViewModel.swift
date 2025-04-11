//
//  File.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
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

extension TimeCardView {
    @Observable
    class ViewModel {
        var entries: [TimeCardEntry] = [TimeCardEntry.example]
        
        var totalTime: TimeInterval {
            entries.reduce(0) { $0 + $1.endTime.timeIntervalSince($1.startTime) }
        }
    }
}
