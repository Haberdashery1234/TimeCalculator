//
//  TimeCardView_ViewModelTests.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import Testing
import Foundation
@testable import TimeCalculator

@Suite("Time Card View Model Tests")
struct TimeCardViewModelTests {

    private func date(hour: Int, minute: Int, day: Int = 1) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    @Test("A fresh view model starts seeded with a placeholder example entry")
    func startsWithSeededExampleEntry() {
        let viewModel = TimeCardViewModel()

        #expect(viewModel.entries.count == 1)
        #expect(viewModel.entries.first?.id == TimeCardEntry.example.id)
    }

    @Test("Total time sums hours across all entries")
    func totalTimeSumsEntries() {
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
    }
    
    @Test("Total time is zero when there are no entries")
    func totalTimeWithNoEntries() {
        let viewModel = TimeCardViewModel()
        viewModel.entries = []

        #expect(viewModel.totalTime == 0)
    }

    @Test("An overnight entry adds correctly to the total")
    func overnightEntryAddsCorrectly() {
        let viewModel = TimeCardViewModel()
        viewModel.entries = [
            TimeCardEntry(
                startDate: date(hour: 22, minute: 0, day: 1),
                endDate: date(hour: 6, minute: 0, day: 2)
            )
        ]

        // Should be +8 hours (28,800 seconds)
        #expect(viewModel.totalTime == 28800)
    }
    
    @Test("Multiple overnight entries sum correctly")
    func multipleOvernightEntries() {
        let viewModel = TimeCardViewModel()
        viewModel.entries = [
            // Night shift 1: 10pm-6am (8 hours)
            TimeCardEntry(
                startDate: date(hour: 22, minute: 0, day: 1),
                endDate: date(hour: 6, minute: 0, day: 2)
            ),
            // Day shift: 9am-5pm (8 hours)
            TimeCardEntry(
                startDate: date(hour: 9, minute: 0, day: 2),
                endDate: date(hour: 17, minute: 0, day: 2)
            ),
            // Night shift 2: 11pm-7am (8 hours)
            TimeCardEntry(
                startDate: date(hour: 23, minute: 0, day: 2),
                endDate: date(hour: 7, minute: 0, day: 3)
            )
        ]

        // Should be 24 hours total (86,400 seconds)
        #expect(viewModel.totalTime == 86400)
    }
}
