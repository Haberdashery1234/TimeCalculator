//
//  TimeCardEntry.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation
import SwiftData

@Model
final class TimeCardEntry {
    var id: UUID
    var startDate: Date
    var endDate: Date
    
    var hours: Double {
        Double(endDate.timeIntervalSince(startDate)) / 3600
    }
    
    /// The primary date for this entry (uses the start date)
    var date: Date {
        startDate
    }
    
    var formattedEntryDate: String {
        formatEntryDate()
    }
    
    var formattedStartTime: String {
        formatTime(startDate)
    }
    
    var formattedEndTime: String {
        formatTime(endDate)
    }
    
    var formatTotalTime: String {
        formatTimeInterval(endDate.timeIntervalSince(startDate))
    }
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
    
    static let example: TimeCardEntry = {
        let now = Date()
        return TimeCardEntry(
            startDate: now,
            endDate: now.addingTimeInterval(3600)
        )
    }()
    
    // MARK: - Formatting Helpers
    
    private func formatEntryDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let startDateStr = formatter.string(from: startDate)
        
        // If overnight, show both dates
        if !Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            let endDateStr = formatter.string(from: endDate)
            return "\(startDateStr) - \(endDateStr)"
        }
        
        return startDateStr
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
}
