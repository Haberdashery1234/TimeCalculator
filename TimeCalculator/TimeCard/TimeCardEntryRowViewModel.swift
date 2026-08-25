//
//  TimeCardEntryRowViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation

@Observable
final class TimeCardEntryRowViewModel {
    var entry: TimeCardEntry
    
    var formattedEntryDate: String {
        formatEntryDate(entry)
    }
    
    var formattedStartTime: String {
        formatTime(entry.startDate)
    }
    
    var formattedEndTime: String {
        formatTime(entry.endDate)
    }
    
    init(entry: TimeCardEntry) {
        self.entry = entry
    }
    
    // MARK: - Formatting Helpers
    
    private func formatEntryDate(_ entry: TimeCardEntry) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let startDateStr = formatter.string(from: entry.startDate)
        
        // If overnight, show both dates
        if !Calendar.current.isDate(entry.startDate, inSameDayAs: entry.endDate) {
            let endDateStr = formatter.string(from: entry.endDate)
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
}
