//
//  TimeCardViewModelTests.swift
//  TimeCalculatorTests
//
//  Created by Christian Grise on 5/6/25.
//

import Testing
import Foundation

struct TimeCardViewModelTests {

    @Test func test_timeCardEntry() async throws {
        let now = Date.now
        let timeCardEntry = TimeCardEntry(date: now, startTime: now, endTime: now.addingTimeInterval(3600))
        assert(timeCardEntry.hours == 1)
    }

}
