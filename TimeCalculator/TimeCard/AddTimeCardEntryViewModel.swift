//
//  AddTimeCardEntryViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation

@Observable
final class AddTimeCardEntryViewModel {
    var startDate: Date
    var endDate: Date
    var isOvernightShift: Bool = false
    
    init(startDate: Date = Date(), endDate: Date = Date()) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    // MARK: - Computed Properties
    
    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
    
    var isValid: Bool {
        duration >= 0
    }
    
    var formattedDuration: String {
        if duration < 0 {
            return "Invalid (end before start)"
        }
        
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours == 0 {
            return "\(minutes) min"
        } else if minutes == 0 {
            return "\(hours) hr"
        } else {
            return "\(hours) hr \(minutes) min"
        }
    }
    
    // MARK: - Actions
    
    func handleOvernightToggle(_ newValue: Bool) {
        if newValue {
            // When toggled on, set end date to next day
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? endDate
        } else {
            // When toggled off, set end date to same day as start
            endDate = combineDateAndTime(date: startDate, time: endDate)
        }
    }
    
    func handleStartDateChange() {
        // Keep end date in sync if not an overnight shift
        if !isOvernightShift {
            endDate = combineDateAndTime(date: startDate, time: endDate)
        }
    }
    
    func createEntry() -> TimeCardEntry {
        TimeCardEntry(startDate: startDate, endDate: endDate)
    }
    
    // MARK: - Helper Methods
    
    private func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combined = DateComponents()
        combined.year = dateComponents.year
        combined.month = dateComponents.month
        combined.day = dateComponents.day
        combined.hour = timeComponents.hour
        combined.minute = timeComponents.minute
        
        return calendar.date(from: combined) ?? time
    }
}

