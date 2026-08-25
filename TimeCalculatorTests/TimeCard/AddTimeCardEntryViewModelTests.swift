//
//  AddTimeCardEntryViewModelTests.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Testing
import Foundation
@testable import TimeCalculator

@Suite("Add Time Card Entry View Model Tests")
struct AddTimeCardEntryViewModelTests {
    
    private func date(hour: Int, minute: Int, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
    
    @Test("Calculates duration correctly for same-day shift")
    func calculatesSameDayDuration() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        // 8 hours = 28,800 seconds
        #expect(viewModel.duration == 28800)
    }
    
    @Test("Calculates duration correctly for overnight shift")
    func calculatesOvernightDuration() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 22, minute: 0, day: 1),
            endDate: date(hour: 6, minute: 0, day: 2)
        )
        
        // 8 hours = 28,800 seconds
        #expect(viewModel.duration == 28800)
    }
    
    @Test("Detects invalid shift when end is before start")
    func detectsInvalidShift() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 17, minute: 0, day: 1),
            endDate: date(hour: 9, minute: 0, day: 1)
        )
        
        #expect(!viewModel.isValid)
        #expect(viewModel.duration < 0)
    }
    
    @Test("Formats duration with hours and minutes")
    func formatsDurationWithHoursAndMinutes() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 12, minute: 30, day: 1)
        )
        
        #expect(viewModel.formattedDuration == "3 hr 30 min")
    }
    
    @Test("Formats duration with only hours")
    func formatsDurationWithOnlyHours() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        #expect(viewModel.formattedDuration == "8 hr")
    }
    
    @Test("Formats duration with only minutes")
    func formatsDurationWithOnlyMinutes() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 9, minute: 45, day: 1)
        )
        
        #expect(viewModel.formattedDuration == "45 min")
    }
    
    @Test("Formats invalid duration")
    func formatsInvalidDuration() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 17, minute: 0, day: 1),
            endDate: date(hour: 9, minute: 0, day: 1)
        )
        
        #expect(viewModel.formattedDuration == "Invalid (end before start)")
    }
    
    @Test("Handle overnight toggle adds one day to end date")
    func handleOvernightToggleAddsDay() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 22, minute: 0, day: 1),
            endDate: date(hour: 6, minute: 0, day: 1)
        )
        
        // Initially invalid (same day, end before start)
        #expect(!viewModel.isValid)
        
        // Toggle overnight
        viewModel.isOvernightShift = true
        viewModel.handleOvernightToggle(true)
        
        // Should now be valid (end is next day)
        #expect(viewModel.isValid)
        
        let calendar = Calendar.current
        let endDay = calendar.component(.day, from: viewModel.endDate)
        #expect(endDay == 2)
    }
    
    @Test("Handle overnight toggle off syncs dates")
    func handleOvernightToggleOffSyncsDates() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 2)
        )
        
        viewModel.isOvernightShift = true
        
        // Toggle off
        viewModel.handleOvernightToggle(false)
        
        // Should sync end date to same day as start
        let calendar = Calendar.current
        let startDay = calendar.component(.day, from: viewModel.startDate)
        let endDay = calendar.component(.day, from: viewModel.endDate)
        #expect(startDay == endDay)
    }
    
    @Test("Handle start date change syncs end date for non-overnight shift")
    func handleStartDateChangeSyncsEndDate() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        // Update start date to day 5
        viewModel.startDate = date(hour: 10, minute: 0, day: 5)
        viewModel.handleStartDateChange()
        
        // End date should also be day 5
        let calendar = Calendar.current
        let endDay = calendar.component(.day, from: viewModel.endDate)
        #expect(endDay == 5)
        
        // Time should be preserved
        let endHour = calendar.component(.hour, from: viewModel.endDate)
        #expect(endHour == 17)
    }
    
    @Test("Handle start date change doesn't sync for overnight shift")
    func handleStartDateChangeDoesntSyncForOvernightShift() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 22, minute: 0, day: 1),
            endDate: date(hour: 6, minute: 0, day: 2)
        )
        
        viewModel.isOvernightShift = true
        
        // Update start date to day 5
        viewModel.startDate = date(hour: 22, minute: 0, day: 5)
        viewModel.handleStartDateChange()
        
        // End date should still be day 2 (not synced)
        let calendar = Calendar.current
        let endDay = calendar.component(.day, from: viewModel.endDate)
        #expect(endDay == 2)
    }
    
    @Test("Creates valid TimeCardEntry")
    func createsValidEntry() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        let entry = viewModel.createEntry()
        
        #expect(entry.startDate == viewModel.startDate)
        #expect(entry.endDate == viewModel.endDate)
        #expect(entry.hours == 8.0)
    }
    
    @Test("Zero duration shift")
    func zeroDurationShift() {
        let sameTime = date(hour: 9, minute: 0, day: 1)
        let viewModel = AddTimeCardEntryViewModel(
            startDate: sameTime,
            endDate: sameTime
        )
        
        #expect(viewModel.duration == 0)
        #expect(viewModel.isValid)
        #expect(viewModel.formattedDuration == "0 min")
    }
    
    @Test("Multi-day shift (48 hours)")
    func multiDayShift() {
        let viewModel = AddTimeCardEntryViewModel(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 9, minute: 0, day: 3)
        )
        
        // 48 hours = 172,800 seconds
        #expect(viewModel.duration == 172800)
        #expect(viewModel.formattedDuration == "48 hr")
    }
}
