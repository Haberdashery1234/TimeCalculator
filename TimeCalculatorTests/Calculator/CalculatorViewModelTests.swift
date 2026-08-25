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
}
