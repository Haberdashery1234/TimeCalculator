//
//  TimeCardViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import Foundation

@Observable
final class TimeCardViewModel {
    var entries: [TimeCardEntry] = [TimeCardEntry.example]
    
    var totalTime: TimeInterval {
        entries.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
    }
    
    var formattedTotalTime: String {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        return String(format: "%d:%02d", hours, minutes)
    }
}
