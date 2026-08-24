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
    
    // MARK: - Computed Properties
    
    var displayText: String {
        let timeText = currentInput.isEmpty ? "00:00" : formatAsTime(currentInput)
        return isNegative ? "-\(timeText)" : timeText
    }
    
    var resultText: String {
        formatTimeInterval(calculateExpression())
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
    }
    
    func performOperation(_ operation: String) {
        expression += displayText + " \(operation) "
        currentInput = ""
        isNegative = false
    }
    
    func calculate() {
        let result = calculateExpression()
        
        // Track if result is negative
        isNegative = result < 0
        
        // Convert result back to digit string
        let resultString = formatTimeInterval(result)
        let components = resultString.replacingOccurrences(of: "-", with: "").split(separator: ":")
        
        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            // Store as raw digits (removes leading zeros naturally)
            currentInput = "\(hours)\(String(format: "%02d", minutes))"
        }
        
        expression = ""
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
    
    /// Parses and evaluates the current expression
    private func calculateExpression() -> TimeInterval {
        let fullExpression = expression + displayText
        let cleanExpression = fullExpression.replacingOccurrences(of: " ", with: "")
        
        guard !cleanExpression.isEmpty else { return 0 }
        
        // Parse time values and operators
        var timeValues: [String] = []
        var operators: [String] = []
        var currentValue = ""
        
        for char in cleanExpression {
            if char == "+" || char == "-" {
                if !currentValue.isEmpty {
                    timeValues.append(currentValue)
                    currentValue = ""
                }
                operators.append(String(char))
            } else {
                currentValue.append(char)
            }
        }
        
        if !currentValue.isEmpty {
            timeValues.append(currentValue)
        }
        
        // Calculate result
        guard !timeValues.isEmpty else { return 0 }
        
        var result = timeToSeconds(timeValues[0])
        
        for (index, op) in operators.enumerated() {
            guard index + 1 < timeValues.count else { break }
            let value = timeToSeconds(timeValues[index + 1])
            result += op == "+" ? value : -value
        }
        
        return result
    }
}
