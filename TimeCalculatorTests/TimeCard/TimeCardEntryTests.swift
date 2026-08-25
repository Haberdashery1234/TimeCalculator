//
//  TimeCardEntryTests.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Testing
import Foundation
@testable import TimeCalculator

@Suite("Time Card Entry Tests")
struct TimeCardEntryTests {

    private func date(hour: Int, minute: Int, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    @Test("An 8-hour shift computes hours correctly")
    func normalShiftHours() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )

        #expect(entry.hours == 8.0)
    }

    @Test("A shift with a partial hour computes a fractional value")
    func partialHourShift() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 13, minute: 30, day: 1)
        )

        #expect(entry.hours == 4.5)
    }

    @Test("A zero-length shift computes zero hours")
    func zeroLengthShift() {
        let sameTime = date(hour: 9, minute: 0, day: 1)
        let entry = TimeCardEntry(startDate: sameTime, endDate: sameTime)

        #expect(entry.hours == 0.0)
    }

    @Test("An overnight shift from 22:00 to 06:00 computes 8 hours")
    func overnightShiftStaysPositive() {
        // Start at 22:00 on day 1, end at 06:00 on day 2
        let entry = TimeCardEntry(
            startDate: date(hour: 22, minute: 0, day: 1),
            endDate: date(hour: 6, minute: 0, day: 2)
        )

        #expect(entry.hours == 8.0)
    }
    
    @Test("An overnight shift from 23:30 to 07:45 computes correct hours")
    func overnightShiftWithPartialHours() {
        // Start at 23:30 on day 1, end at 07:45 on day 2
        // Should be 8.25 hours (8 hours 15 minutes)
        let entry = TimeCardEntry(
            startDate: date(hour: 23, minute: 30, day: 1),
            endDate: date(hour: 7, minute: 45, day: 2)
        )

        #expect(entry.hours == 8.25)
    }
    
    @Test("End date before start date produces negative hours")
    func endBeforeStartIsNegative() {
        let entry = TimeCardEntry(
            startDate: date(hour: 17, minute: 0, day: 2),
            endDate: date(hour: 9, minute: 0, day: 1)
        )

        #expect(entry.hours < 0)
    }
    
    @Test("Date property returns the start date")
    func datePropertyReturnsStartDate() {
        let startDate = date(hour: 9, minute: 0, day: 5)
        let entry = TimeCardEntry(
            startDate: startDate,
            endDate: date(hour: 17, minute: 0, day: 5)
        )

        #expect(entry.date == startDate)
    }
    
    @Test("Formats entry date correctly")
    func formatsEntryDate() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 30, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        // Should contain date components (format may vary by locale)
        let entryDate = entry.formattedEntryDate
        #expect(!entryDate.isEmpty)
        #expect(entryDate.contains("Jan") || entryDate.contains("1"))
    }
    
    @Test("Formats start time correctly")
    func formatsStartTime() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 30, day: 1),
            endDate: date(hour: 17, minute: 0, day: 1)
        )
        
        // Should contain time components (format may vary by locale)
        let startTime = entry.formattedStartTime
        #expect(!startTime.isEmpty)
        #expect(startTime.contains("9") && startTime.contains("30"))
    }
    
    @Test("Formats end time correctly")
    func formatsEndTime() {
        let entry = TimeCardEntry(
            startDate: date(hour: 9, minute: 0, day: 1),
            endDate: date(hour: 17, minute: 45, day: 1)
        )
        
        // Should contain time components (format may vary by locale)
        let endTime = entry.formattedEndTime
        #expect(!endTime.isEmpty)
        #expect(endTime.contains("5") || endTime.contains("17"))
        #expect(endTime.contains("45"))
    }
    
    @Test("Formats total time correctly")
    func formatsTotalTime() {
        let viewModel = TimeCardViewModel()
        viewModel.entries = [
            TimeCardEntry(
                startDate: date(hour: 9, minute: 0, day: 1),
                endDate: date(hour: 17, minute: 0, day: 1)
            ),
            TimeCardEntry(
                startDate: date(hour: 8, minute: 0, day: 2),
                endDate: date(hour: 12, minute: 30, day: 2)
            )
        ]

        // 8h + 4.5h = 12.5h = 45,000 seconds
        #expect(viewModel.totalTime == 45000)
        
        // Should contain time components (format may vary by locale)
        let totalTime = viewModel.formattedTotalTime
        #expect(totalTime == "12:30")
    }
}
