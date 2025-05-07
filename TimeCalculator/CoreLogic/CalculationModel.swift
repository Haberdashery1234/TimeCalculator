//
//  CalculationModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import Foundation

struct CalculationModel {
    // Time conversion functions
    func formatTimeFromDigits(_ digits: [Int]) -> String {
        let paddedDigits = digits.count < 4
            ? Array(repeating: 0, count: max(0, 4 - digits.count)) + digits
            : digits
        
        var tempArray = paddedDigits
        let minutesOne = String(tempArray.popLast() ?? 0)
        let minutesTen = String(tempArray.popLast() ?? 0)
        
        return "\(tempArray.map { String($0) }.joined()):\(minutesTen)\(minutesOne)"
    }
    
    func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let components = timeString.split(separator: ":")
        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            return TimeInterval(hours * 3600 + minutes * 60)
        }
        return 0
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalMinutes = Int(abs(interval) / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = interval < 0 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }
    
    func calculateResult(from expression: String) -> String {
        let cleanExpression = expression.replacingOccurrences(of: " ", with: "")
        
        // Parse the expression
        var timeComponents: [String] = []
        var operators: [String] = []
        var currentComponent = ""
        
        for char in cleanExpression {
            if char == "+" || char == "-" {
                if !currentComponent.isEmpty {
                    timeComponents.append(currentComponent)
                    currentComponent = ""
                }
                operators.append(String(char))
            } else {
                currentComponent += String(char)
            }
        }
        
        // Add the last component
        if !currentComponent.isEmpty {
            timeComponents.append(currentComponent)
        }
        
        // Calculate result
        var totalSeconds: TimeInterval = 0
        
        if !timeComponents.isEmpty {
            totalSeconds = timeStringToSeconds(timeComponents[0])
            
            for i in 0..<operators.count {
                if i < timeComponents.count - 1 {
                    let timeValue = timeStringToSeconds(timeComponents[i+1])
                    totalSeconds += operators[i] == "+" ? timeValue : -timeValue
                }
            }
        }
        
        return formatTimeInterval(totalSeconds)
    }
}
