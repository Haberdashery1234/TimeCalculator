//
//  TimeCalculatorTests.swift
//  TimeCalculatorTests
//
//  Created by Christian Grise on 4/9/25.
//

import Testing
import Foundation

struct CalculationModelTests {

    @Test func test_formatTimeFromDigits() async throws {
        let model = CalculationModel()
        
        assert(model.formatTimeFromDigits([1,2,3,4]) == "12:34")
        assert(model.formatTimeFromDigits([1,2,3]) == "01:23")
        assert(model.formatTimeFromDigits([1,2]) == "00:12")
        assert(model.formatTimeFromDigits([1]) == "00:01")
        assert(model.formatTimeFromDigits([]) == "00:00")
    }

    @Test func test_timeStringToSeconds() async throws {
        let model = CalculationModel()
        assert(model.timeStringToSeconds("12:34") == 45240)
        assert(model.timeStringToSeconds("12:98") == 49080)
        assert(model.timeStringToSeconds("") == 0)
    }
    
    @Test func test_formatTimeInterval() async throws {
        let model = CalculationModel()
        
        assert(model.formatTimeInterval(3600) == "01:00")
        assert(model.formatTimeInterval(-3600) == "-01:00")
        assert(model.formatTimeInterval(0) == "00:00")
    }
    
    @Test func test_calculateResult() async throws {
        let model = CalculationModel()
        var calculationString = "12:34 + 01:00 - 03:15"
        assert(model.calculateResult(from: calculationString) == "10:19")
        calculationString = "12:34+01:00 -03:15"
        assert(model.calculateResult(from: calculationString) == "10:19")
    }
}
