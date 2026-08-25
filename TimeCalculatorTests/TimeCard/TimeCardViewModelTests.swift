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

    private func date(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 1
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    // NOTE: this documents a real behavior found in the audit (issue #4),
    // not a crash or a math error - every fresh ViewModel seeds itself with
    // TimeCardEntry.example, which also counts toward totalTime. This test
    // exists so it's obvious (and fails loudly) if that seeding is removed
    // without updating the assumption elsewhere, and as a reminder that it's
    // still open.
    @Test("A fresh view model starts seeded with a placeholder example entry")
    func startsWithSeededExampleEntry() {
        let viewModel = TimeCardView.ViewModel()

        #expect(viewModel.entries.count == 1)
        #expect(viewModel.entries.first?.id == TimeCardEntry.example.id)
    }

    @Test("Total time sums hours across all entries")
    func totalTimeSumsEntries() {
        let viewModel = TimeCardView.ViewModel()
        viewModel.entries = [
            TimeCardEntry(
                date: date(hour: 0, minute: 0),
                startTime: date(hour: 9, minute: 0),
                endTime: date(hour: 17, minute: 0)
            ),
            TimeCardEntry(
                date: date(hour: 0, minute: 0),
                startTime: date(hour: 8, minute: 0),
                endTime: date(hour: 12, minute: 30)
            )
        ]

        // 8h + 4.5h = 12.5h = 45,000 seconds
        #expect(viewModel.totalTime == 45000)
    }

    @Test("Total time is zero when there are no entries")
    func totalTimeWithNoEntries() {
        let viewModel = TimeCardView.ViewModel()
        viewModel.entries = []

        #expect(viewModel.totalTime == 0)
    }

    @Test(
        "KNOWN BUG (audit #2): an overnight entry silently subtracts from the total instead of adding",
        .disabled("Same root cause as TimeCardEntryTests.overnightShiftShouldStayPositive")
    )
    func overnightEntryShouldAddNotSubtract() {
        let viewModel = TimeCardView.ViewModel()
        viewModel.entries = [
            TimeCardEntry(
                date: date(hour: 0, minute: 0),
                startTime: date(hour: 22, minute: 0),
                endTime: date(hour: 6, minute: 0)
            )
        ]

        // Should be +8 hours (28,800 seconds), not -16 hours.
        #expect(viewModel.totalTime == 28800)
    }
}
