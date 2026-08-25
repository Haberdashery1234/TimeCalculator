//
//  CalculatorViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import Foundation

@Observable
final class CalculatorViewModel {
    // MARK: - Published State

    private(set) var currentInput = ""
    private(set) var expression = ""
    private(set) var isNegative = false

    // MARK: - Internal Calculation State
    //
    // The running total is tracked as an actual signed `TimeInterval` that's
    // updated incrementally each time an operator is pressed, rather than by
    // re-parsing the concatenated display string on every keystroke. The old
    // approach re-parsed `expression + displayText` as a string and split on
    // "+"/"-", which couldn't tell a subtraction operator apart from the
    // leading minus sign on a negative value carried over from a previous
    // result — so continuing a calculation after a negative result produced
    // the wrong sign. `expression` is now purely a cosmetic trail of what's
    // been entered so far; it's never parsed back.

    private var runningTotal: TimeInterval = 0
    private var pendingOperator: Character?
    private var hasPendingValue = false

    // MARK: - Computed Properties

    var displayText: String {
        let timeText = currentInput.isEmpty ? "00:00" : formatAsTime(currentInput)
        return isNegative ? "-\(timeText)" : timeText
    }

    var resultText: String {
        formatTimeInterval(previewTotal())
    }

    // MARK: - Public Actions

    func appendDigit(_ digit: Int) {
        currentInput.append(String(digit))
    }

    func appendDoubleZero() {
        currentInput.append("00")
    }

    func backspace() {
        guard !currentInput.isEmpty else { return }
        currentInput.removeLast()
    }

    func clear() {
        currentInput = ""
        expression = ""
        isNegative = false
        runningTotal = 0
        pendingOperator = nil
        hasPendingValue = false
    }

    func performOperation(_ operation: String) {
        let value = currentValueSeconds()
        if let pendingOperator {
            runningTotal += pendingOperator == "+" ? value : -value
        } else {
            runningTotal = value
        }
        hasPendingValue = true
        pendingOperator = operation.first

        expression += displayText + " \(operation) "
        currentInput = ""
        isNegative = false
    }

    func calculate() {
        let result = previewTotal()
        isNegative = result < 0

        // Convert result back to digit string so it becomes the new
        // "current input" that further digits/operations build on.
        let resultString = formatTimeInterval(result)
        let components = resultString.replacingOccurrences(of: "-", with: "").split(separator: ":")

        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            currentInput = "\(hours)\(String(format: "%02d", minutes))"
        }

        expression = ""
        runningTotal = 0
        pendingOperator = nil
        hasPendingValue = false
    }

    // MARK: - Private Formatting Functions

    /// Formats a string of digits as HH:MM time
    private func formatAsTime(_ digits: String) -> String {
        // Pad to at least 4 digits
        let padded = String(repeating: "0", count: max(0, 4 - digits.count)) + digits

        // Split into hours and minutes (last 2 digits are minutes)
        let index = padded.index(padded.endIndex, offsetBy: -2)
        let hours = String(padded[..<index])
        let minutes = String(padded[index...])

        return "\(hours):\(minutes)"
    }

    /// Converts a time string (HH:MM) to seconds
    private func timeToSeconds(_ timeString: String) -> TimeInterval {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0
        }
        return TimeInterval(hours * 3600 + minutes * 60)
    }

    /// Formats a TimeInterval as HH:MM
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalMinutes = Int(abs(interval) / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = interval < 0 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }

    // MARK: - Private Calculation Logic

    /// The signed value (in seconds) of whatever is currently displayed,
    /// honoring `isNegative` for a carried-over negative result.
    private func currentValueSeconds() -> TimeInterval {
        let magnitude = timeToSeconds(currentInput.isEmpty ? "00:00" : formatAsTime(currentInput))
        return isNegative ? -magnitude : magnitude
    }

    /// The total if `=` were pressed right now, without mutating state.
    private func previewTotal() -> TimeInterval {
        guard let pendingOperator else {
            return hasPendingValue ? runningTotal : currentValueSeconds()
        }
        let value = currentValueSeconds()
        return runningTotal + (pendingOperator == "+" ? value : -value)
    }
}
