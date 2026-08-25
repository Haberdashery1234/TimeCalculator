//
//  CalculatorViewModelTests.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import Testing
@testable import TimeCalculator

@Suite("Calculator ViewModel Tests")
struct CalculatorViewModelTests {

    // MARK: - Test Helpers

    /// Helper to enter a time value like "01:30" by appending digits 1, 3, 0
    private func enterTime(_ viewModel: CalculatorViewModel, hours: Int, minutes: Int) {
        let timeString = String(format: "%d%02d", hours, minutes)
        for char in timeString {
            if let digit = Int(String(char)) {
                viewModel.appendDigit(digit)
            }
        }
    }

    // MARK: - Digit entry

    @Test("Appending digits formats time correctly")
    func appendDigits() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)

        #expect(viewModel.displayText == "12:30")
    }

    @Test("Double zero appends two zeros")
    func doubleZero() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(5)
        viewModel.appendDoubleZero()

        #expect(viewModel.displayText == "05:00")
    }

    @Test("Double zero on empty input still formats correctly")
    func doubleZeroOnEmptyInput() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDoubleZero()

        #expect(viewModel.displayText == "00:00")
    }

    @Test("Backspace removes last digit")
    func backspace() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)
        viewModel.backspace()

        #expect(viewModel.displayText == "00:12")
    }

    @Test("Backspace on empty input does nothing (no crash)")
    func backspaceOnEmptyInput() {
        let viewModel = CalculatorViewModel()

        viewModel.backspace()

        #expect(viewModel.displayText == "00:00")
    }

    @Test("Digit entry beyond 4 digits grows the hours field instead of truncating")
    func largeDigitEntry() {
        let viewModel = CalculatorViewModel()

        for digit in [1, 2, 3, 4, 5, 6] {
            viewModel.appendDigit(digit)
        }

        #expect(viewModel.displayText == "1234:56")
    }

    // MARK: - Clear

    @Test("Clear resets all state")
    func clear() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(5)
        viewModel.performOperation("+")
        viewModel.appendDigit(3)
        viewModel.clear()

        #expect(viewModel.displayText == "00:00")
        #expect(viewModel.expression == "")
        #expect(viewModel.resultText == "00:00")
    }

    @Test("Clear after a completed calculation also resets the negative flag")
    func clearAfterNegativeResult() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.calculate()
        viewModel.clear()

        #expect(viewModel.displayText == "00:00")
        #expect(viewModel.isNegative == false)
    }

    // MARK: - Single operations

    @Test("Addition operation formats correctly")
    func addition() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("+")

        #expect(viewModel.expression == "01:30 + ")
        #expect(viewModel.displayText == "00:00")
    }

    @Test("Calculate adds times correctly")
    func calculateAddition() {
        let viewModel = CalculatorViewModel()

        // 01:30 + 02:45 = 04:15
        viewModel.appendDigit(1)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("+")
        viewModel.appendDigit(2)
        viewModel.appendDigit(4)
        viewModel.appendDigit(5)
        viewModel.calculate()

        #expect(viewModel.displayText == "04:15")
        #expect(viewModel.expression == "")
    }

    @Test("Calculate subtracts times correctly")
    func calculateSubtraction() {
        let viewModel = CalculatorViewModel()

        // 05:30 - 02:15 = 03:15
        viewModel.appendDigit(5)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDigit(1)
        viewModel.appendDigit(5)
        viewModel.calculate()

        #expect(viewModel.displayText == "03:15")
    }

    @Test("Subtracting to exactly zero shows 00:00, not negative")
    func subtractToExactZero() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "00:00")
        #expect(viewModel.isNegative == false)
    }

    // MARK: - Chained operations

    @Test("Multiple operations calculate correctly")
    func multipleOperations() {
        let viewModel = CalculatorViewModel()

        // 10:00 + 02:30 - 01:15 = 11:15
        viewModel.appendDigit(1)
        viewModel.appendDigit(0)
        viewModel.appendDoubleZero()
        viewModel.performOperation("+")
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("-")
        viewModel.appendDigit(1)
        viewModel.appendDigit(1)
        viewModel.appendDigit(5)

        #expect(viewModel.resultText == "11:15")

        viewModel.calculate()
        #expect(viewModel.displayText == "11:15")
    }

    @Test("Result shows running calculation")
    func runningResult() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(8)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("+")
        viewModel.appendDigit(1)
        viewModel.appendDigit(4)
        viewModel.appendDigit(5)

        // Should show 10:15 as result before pressing equals
        #expect(viewModel.resultText == "10:15")
    }

    @Test("Consecutive operator presses with no digits between them don't corrupt the total")
    func consecutiveOperatorsWithoutDigits() {
        let viewModel = CalculatorViewModel()

        viewModel.performOperation("+")
        viewModel.performOperation("+")
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "01:00")
    }

    @Test("Pressing equals with nothing entered stays at 00:00")
    func equalsOnFreshState() {
        let viewModel = CalculatorViewModel()

        viewModel.calculate()

        #expect(viewModel.displayText == "00:00")
        #expect(viewModel.isNegative == false)
    }

    // MARK: - Negative results
    //
    // These cover the sign-handling bug found during the code audit: the
    // original implementation re-parsed the concatenated expression string
    // on every calculation, which couldn't distinguish a subtraction
    // operator from the leading "-" on a negative value carried over from a
    // previous result. `continueWithNegativeResult` and
    // `chainedDoubleNegative` below are the cases that used to fail.

    @Test("Negative result displays with minus sign")
    func negativeResult() {
        let viewModel = CalculatorViewModel()

        // 02:00 - 05:00 = -03:00
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(5)
        viewModel.appendDoubleZero()

        #expect(viewModel.resultText == "-03:00")
    }

    @Test("Negative result preserves minus sign after equals")
    func negativeResultAfterEquals() {
        let viewModel = CalculatorViewModel()

        // 01:00 - 02:00 = -01:00
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "-01:00")
        #expect(viewModel.isNegative == true)
    }

    @Test("Can continue calculation with negative result")
    func continueWithNegativeResult() {
        let viewModel = CalculatorViewModel()

        // 01:00 - 02:00 = -01:00, then + 03:00 = 02:00
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "-01:00")

        viewModel.performOperation("+")
        viewModel.appendDigit(3)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "02:00")
        #expect(viewModel.isNegative == false)
    }

    @Test("Adding a smaller value to a negative result keeps it negative, with the right magnitude")
    func addSmallerValueToNegativeResult() {
        let viewModel = CalculatorViewModel()

        // 01:00 - 02:00 = -01:00, then + 00:30 = -00:30
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        viewModel.performOperation("+")
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.calculate()

        #expect(viewModel.displayText == "-00:30")
        #expect(viewModel.isNegative == true)
    }

    @Test("Chaining another subtraction onto a negative result stays negative and correct")
    func chainedDoubleNegative() {
        let viewModel = CalculatorViewModel()

        // 01:00 - 03:00 - 01:00 = -03:00
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(3)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "-03:00")
        #expect(viewModel.isNegative == true)
    }

    @Test("A negative result can flip back to positive mid-chain and continue correctly")
    func negativeFlipsPositiveMidChain() {
        let viewModel = CalculatorViewModel()

        // 01:00 - 03:00 = -02:00, + 05:00 = 03:00, - 01:00 = 02:00
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(3)
        viewModel.appendDoubleZero()
        viewModel.performOperation("+")
        viewModel.appendDigit(5)
        viewModel.appendDoubleZero()
        viewModel.performOperation("-")
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "02:00")
        #expect(viewModel.isNegative == false)
    }

    // MARK: - Edge Cases & Boundary Conditions

    @Test("Maximum reasonable time value displays correctly")
    func maximumTimeValue() {
        let viewModel = CalculatorViewModel()

        // Test a very large number of hours (e.g., 9999:59)
        for digit in [9, 9, 9, 9, 5, 9] {
            viewModel.appendDigit(digit)
        }

        #expect(viewModel.displayText == "9999:59")
    }

    @Test("Single digit entry formats with leading zeros")
    func singleDigitEntry() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(5)

        #expect(viewModel.displayText == "00:05")
    }

    @Test("Minutes portion correctly displays values 00-59")
    func minutesDisplayCorrectly() {
        let viewModel = CalculatorViewModel()

        // Test 00:59
        viewModel.appendDigit(5)
        viewModel.appendDigit(9)

        #expect(viewModel.displayText == "00:59")

        viewModel.clear()

        // Test 01:23
        viewModel.appendDigit(1)
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)

        #expect(viewModel.displayText == "01:23")
    }

    @Test("Performing operation immediately after equals continues calculation correctly")
    func operationAfterEquals() {
        let viewModel = CalculatorViewModel()

        // 02:00 + 03:00 = 05:00, then + 01:00 = 06:00
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()
        viewModel.performOperation("+")
        viewModel.appendDigit(3)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "05:00")

        viewModel.performOperation("+")
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "06:00")
    }

    @Test("Multiple backspaces clear current input completely")
    func multipleBackspaces() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)
        viewModel.appendDigit(4)

        viewModel.backspace()
        viewModel.backspace()
        viewModel.backspace()
        viewModel.backspace()

        #expect(viewModel.displayText == "00:00")
    }

    @Test("Expression text updates correctly during operations")
    func expressionTextUpdates() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()

        #expect(viewModel.expression == "")

        viewModel.performOperation("+")

        #expect(viewModel.expression == "02:00 + ")

        viewModel.appendDigit(1)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.performOperation("-")

        #expect(viewModel.expression == "02:00 + 01:30 - ")
    }

    @Test("Expression clears after calculation")
    func expressionClearsAfterCalculation() {
        let viewModel = CalculatorViewModel()

        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.performOperation("+")
        viewModel.appendDigit(2)
        viewModel.appendDoubleZero()

        #expect(viewModel.expression != "")

        viewModel.calculate()

        #expect(viewModel.expression == "")
    }

    @Test("Result text shows zero initially")
    func initialResultText() {
        let viewModel = CalculatorViewModel()

        #expect(viewModel.resultText == "00:00")
    }

    @Test("Subtracting from zero produces negative result")
    func subtractFromZero() {
        let viewModel = CalculatorViewModel()

        // 00:00 - 01:00 = -01:00
        viewModel.performOperation("-")
        viewModel.appendDigit(1)
        viewModel.appendDoubleZero()
        viewModel.calculate()

        #expect(viewModel.displayText == "-01:00")
        #expect(viewModel.isNegative == true)
    }

    @Test("Adding to zero with no prior operation works correctly")
    func addToZero() {
        let viewModel = CalculatorViewModel()

        // 00:00 + 02:30 = 02:30
        viewModel.performOperation("+")
        viewModel.appendDigit(2)
        viewModel.appendDigit(3)
        viewModel.appendDigit(0)
        viewModel.calculate()

        #expect(viewModel.displayText == "02:30")
    }

    // MARK: - Performance & Stress Tests

    @Test("Long chain of operations completes without performance issues")
    func longChainOfOperations() {
        let viewModel = CalculatorViewModel()

        // Build a long chain: start at 10:00 and add/subtract 1:00 twenty times
        enterTime(viewModel, hours: 10, minutes: 0)

        for _ in 0..<20 {
            viewModel.performOperation("+")
            enterTime(viewModel, hours: 1, minutes: 0)
        }

        viewModel.calculate()

        // 10:00 + 20 * 01:00 = 30:00
        #expect(viewModel.displayText == "30:00")
    }

    @Test("Rapid digit entry and backspace operations remain consistent")
    func rapidDigitOperations() {
        let viewModel = CalculatorViewModel()

        // Rapidly enter and delete digits
        for _ in 0..<10 {
            viewModel.appendDigit(1)
            viewModel.appendDigit(2)
            viewModel.appendDigit(3)
            viewModel.backspace()
            viewModel.backspace()
            viewModel.backspace()
        }

        #expect(viewModel.displayText == "00:00")
        #expect(viewModel.expression == "")
    }

    // MARK: - Integration Tests

    @Test("Complex real-world scenario: calculating weekly hours")
    func complexWeeklyHoursScenario() {
        let viewModel = CalculatorViewModel()

        // Monday: 8:30
        enterTime(viewModel, hours: 8, minutes: 30)
        viewModel.performOperation("+")

        // Tuesday: 9:15
        enterTime(viewModel, hours: 9, minutes: 15)
        viewModel.performOperation("+")

        // Wednesday: 7:45
        enterTime(viewModel, hours: 7, minutes: 45)
        viewModel.performOperation("+")

        // Thursday: 8:00
        enterTime(viewModel, hours: 8, minutes: 0)
        viewModel.performOperation("+")

        // Friday: 6:30
        enterTime(viewModel, hours: 6, minutes: 30)

        // Total: 40:00
        #expect(viewModel.resultText == "40:00")

        viewModel.calculate()
        #expect(viewModel.displayText == "40:00")
    }
}
