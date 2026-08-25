//
//  TimeCardEntryRowViewModelTests.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Testing
import Foundation
@testable import TimeCalculator

@Suite("Time Card Entry Row View Model Tests")
struct TimeCardEntryRowViewModelTests {
    
    private func date(hour: Int, minute: Int, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone(identifier: "America/New_York")
        return Calendar.current.date(from: components)!
    }
    
    @Test("Formats regular shift with single date")
    func formatsRegularShift() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry)
        
        // Should show single date since it's same day
        #expect(viewModel.formattedEntryDate.contains("Jan 1"))
        #expect(!viewModel.formattedEntryDate.contains(" - "))
    }
    
    @Test("Formats overnight shift with date range")
    func formatsOvernightShift() {
        let entry = TimeCardEntry(
            startDate: date(hour: 22, minute: 0, day: 1),
            endDate: date(hour: 6, minute: 0, day: 2)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry)
        
        // Should show date range for overnight shift
        #expect(viewModel.formattedEntryDate.contains("Jan 1"))
        #expect(viewModel.formattedEntryDate.contains(" - "))
        #expect(viewModel.formattedEntryDate.contains("Jan 2"))
    }
    
    @Test("View model updates when entry changes")
    func viewModelUpdatesWithEntry() {
        let entry1 = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry1)
        
        let firstDate = viewModel.formattedEntryDate
        
        // Update entry
        let entry2 = TimeCardEntry(
            startDate: date(hour: 8, minute: 0, day: 5),
            endDate: date(hour: 16, minute: 0, day: 5)
        )
        viewModel.entry = entry2
        
        // Formatted date should change
        #expect(viewModel.formattedEntryDate != firstDate)
        #expect(viewModel.formattedEntryDate.contains("Jan 5"))
    }
    
    @Test("Handles midnight correctly")
    func handlesMidnight() {
        let entry = TimeCardEntry(
            startDate: date(hour: 0, minute: 0, day: 1),
            endDate: date(hour: 8, minute: 0, day: 1)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry)
        
        // Should format midnight properly
        let startTime = viewModel.formattedStartTime
        #expect(startTime.contains("12") || startTime.contains("00") || startTime.contains("0"))
    }
    
    @Test("Handles noon correctly")
    func handlesNoon() {
        let entry = TimeCardEntry(
            startDate: date(hour: 12, minute: 0, day: 1),
            endDate: date(hour: 13, minute: 0, day: 1)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry)
        
        // Should format noon properly
        let startTime = viewModel.formattedStartTime
        #expect(startTime.contains("12"))
    }
    
    @Test("Multi-day shift shows date range")
    func multiDayShift() {
        // A 48-hour shift
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 9, minute: 0, day: 3)
        )
        let viewModel = TimeCardEntryRowViewModel(entry: entry)
        
        // Should show as date range
        #expect(viewModel.formattedEntryDate.contains("Jan 1"))
        #expect(viewModel.formattedEntryDate.contains(" - "))
        #expect(viewModel.formattedEntryDate.contains("Jan 3"))
    }
}
