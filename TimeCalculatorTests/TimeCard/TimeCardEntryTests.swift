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
            date: date(hour: 0, minute: 0),
            startTime: date(hour: 9, minute: 0),
            endTime: date(hour: 17, minute: 0)
        )

        #expect(entry.hours == 8.0)
    }

    @Test("A shift with a partial hour computes a fractional value")
    func partialHourShift() {
        let entry = TimeCardEntry(
            date: date(hour: 0, minute: 0),
            startTime: date(hour: 9, minute: 0),
            endTime: date(hour: 13, minute: 30)
        )

        #expect(entry.hours == 4.5)
    }

    @Test("A zero-length shift computes zero hours")
    func zeroLengthShift() {
        let sameTime = date(hour: 9, minute: 0)
        let entry = TimeCardEntry(date: sameTime, startTime: sameTime, endTime: sameTime)

        #expect(entry.hours == 0.0)
    }

    // NOTE: this is left disabled rather than fixed - the audit flagged the
    // overnight-shift bug (issue #2), but fixing it means changing how
    // AddTimeCardEntryView builds startTime/endTime (tying them to the
    // selected date and detecting an end time that's "earlier" than start as
    // the next day), which is a separate, larger change from the calculator
    // fix made in this pass. Enable this once that's addressed.
    @Test(
        "KNOWN BUG (audit #2): an overnight shift currently produces negative hours",
        .disabled("Needs AddTimeCardEntryView/TimeCardEntry to be overnight-aware before this can pass")
    )
    func overnightShiftShouldStayPositive() {
        // A 22:00 -> 06:00 shift should be 8 hours, not -16. Today, start and
        // end share the same calendar day (nothing rolls the end time to the
        // next day), so this currently comes out negative.
        let entry = TimeCardEntry(
            date: date(hour: 0, minute: 0),
            startTime: date(hour: 22, minute: 0),
            endTime: date(hour: 6, minute: 0)
        )

        #expect(entry.hours == 8.0)
    }
}
