//
//  ContentView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct CalculatorView: View {
    // MARK: - State
    @State private var enteredDigits = [Int]()
    @State private var displayText = "00:00"
    @State private var fullCalculation = ""
    @State private var result = "00:00"
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Time Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // Display
            VStack(alignment: .trailing) {
                Text(fullCalculation + "\(displayText)")
                    .font(.system(size: 60, weight: .light))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(result)
                    .font(.system(size: 24, weight: .light))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
            .onChange(of: enteredDigits) {
                updateDisplays()
            }
            
            ButtonsView(
                onDigitPress: appendDigit,
                onDoubleZeroPress: appendDoubleZero,
                onClear: clearAll,
                onAddition: { performOperation("+") },
                onSubtraction: { performOperation("-") },
                onEquals: calculate,
                onDelete: backspace
            )
        }
        .padding()
    }
    
    // MARK: - Time Conversion Functions
    
    private func updateDisplays() {
        displayText = formatTimeFromDigits(enteredDigits)
        result = calculateRunningResult()
    }
    
    private func formatTimeFromDigits(_ digits: [Int]) -> String {
        let paddedDigits = digits.count < 4
            ? Array(repeating: 0, count: max(0, 4 - digits.count)) + digits
            : digits
        
        var tempArray = paddedDigits
        let minutesOne = String(tempArray.popLast() ?? 0)
        let minutesTen = String(tempArray.popLast() ?? 0)
        
        return "\(tempArray.map { String($0) }.joined()):\(minutesTen)\(minutesOne)"
    }
    
    private func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let components = timeString.split(separator: ":")
        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            return TimeInterval(hours * 3600 + minutes * 60)
        }
        return 0
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalMinutes = Int(abs(interval) / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = interval < 0 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }
    
    // MARK: - Calculation Logic
    
    private func calculateRunningResult() -> String {
        let expression = fullCalculation + displayText
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
    
    // MARK: - User Actions
    
    private func appendDigit(_ digit: Int) {
        enteredDigits.append(digit)
    }
    
    private func appendDoubleZero() {
        enteredDigits.append(0)
        enteredDigits.append(0)
    }
    
    private func backspace() {
        if !enteredDigits.isEmpty {
            enteredDigits.removeLast()
        }
    }
    
    private func clearAll() {
        enteredDigits.removeAll()
        fullCalculation = ""
        result = "00:00"
    }
    
    private func performOperation(_ operation: String) {
        fullCalculation += displayText + " \(operation) "
        enteredDigits.removeAll()
        result = calculateRunningResult()
    }
    
    private func calculate() {
        displayText = calculateRunningResult()
        fullCalculation = ""
        enteredDigits.removeAll()
    }
}

#Preview {
    CalculatorView()
}
