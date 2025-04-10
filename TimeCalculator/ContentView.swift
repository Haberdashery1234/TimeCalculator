//
//  ContentView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @State var enteredDigits = [Int]()
    
    @State var displayText: String = "00:00"
    @State var fullCalculation: String = ""
    
    @State var runningTotalDisplay: String = "00:00"
    @State var runningTotal: TimeInterval = 0
    
    enum Operation {
        case add, subtract
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Time Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // Display
            VStack(alignment: .trailing) {
                Text(fullCalculation + " \(displayText)")
                    .font(.system(size: 60, weight: .light))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(runningTotalDisplay)
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
                displayText = convertEnteredTimeToDisplay()
                runningTotalDisplay = parseTimeExpression()
            }
            
            ButtonsView(onDigitPress: appendDigit, onDoubleZeroPress: appendDoubleZero, onClear: clearAll, onAddition: addition, onSubtraction: subtraction, onEquals: calculate, onDelete: backspace)
        }
        .padding()
    }
    
    // MARK: - Functions
    
    private func convertEnteredTimeToDisplay() -> String {
        var tempArray = enteredDigits
        if enteredDigits.count < 4 {
            let zerosNeeded = max(0, 4 - enteredDigits.count)

            if zerosNeeded > 0 {
                tempArray = Array(repeating: 0, count: zerosNeeded) + enteredDigits
            }
        }
        
        let minutesOne = String(tempArray.popLast() ?? 0)
        let minutesTen = String(tempArray.popLast() ?? 0)
        
        return "\(tempArray.map { String($0) }.joined()):\(minutesTen)\(minutesOne)"
    }
    
    private func convertEnteredTimeToTimeInterval() -> TimeInterval {
        
        var tempArray = enteredDigits
        if enteredDigits.count < 4 {
            let zerosNeeded = max(0, 4 - enteredDigits.count)

            if zerosNeeded > 0 {
                tempArray = Array(repeating: 0, count: zerosNeeded) + enteredDigits
            }
        }
        
        let minutesOne = tempArray.popLast() ?? 0
        let minutesTen = tempArray.popLast() ?? 0
        
        let hours = Int(tempArray.map { String($0) }.joined()) ?? 0
        let totalMinutes = (hours * 60) + (minutesTen * 10) + minutesOne
        let time = TimeInterval(totalMinutes) * 60
        return time
    }
    
    private func convertRunningTotalToDisplay() -> String {
        // Convert TimeInterval (seconds) to total minutes
        let totalMinutes = Int(runningTotal / 60)
        
        // Extract hours and remaining minutes
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        // Handle negative intervals by adding a sign
        let sign = runningTotal < 0 ? "-" : ""
        
        // Format as "hour:minute" with leading zeros
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }

    
    private func appendDigit(_ digit: Int) {
        enteredDigits.append(digit)
    }
    
    private func appendDoubleZero() {
        enteredDigits.append(0)
        enteredDigits.append(0)
    }
    
    private func clearAll() {
        enteredDigits.removeAll()
        fullCalculation = ""
        runningTotal = 0
    }
    
    private func backspace() {
        _ = enteredDigits.popLast()
    }
    
    private func addition() {
        fullCalculation += convertEnteredTimeToDisplay() + " + "
        enteredDigits.removeAll()
        runningTotalDisplay = parseTimeExpression()
    }
    
    private func subtraction() {
        fullCalculation += convertEnteredTimeToDisplay() + " - "
        runningTotalDisplay = parseTimeExpression()
        enteredDigits.removeAll()
    }
    
    private func calculate() {
        displayText = parseTimeExpression()
        fullCalculation = ""
        enteredDigits.removeAll()
    }
    
    func parseTimeExpression() -> String {
        var runningCalculation = fullCalculation + displayText
        print(runningCalculation)
        let cleanExpression = runningCalculation.replacingOccurrences(of: " ", with: "")
        
        // Split by + or - operators while keeping the operators
        var components: [String] = []
        var currentComponent = ""
        var operations: [String] = []
        
        // First time value doesn't have an operator before it
        var isFirstValue = true
        
        for char in cleanExpression {
            if char == "+" || char == "-" {
                if !isFirstValue {
                    components.append(currentComponent)
                    currentComponent = ""
                }
                operations.append(String(char))
                isFirstValue = false
            } else {
                currentComponent += String(char)
            }
        }
        
        // Add the last component
        if !currentComponent.isEmpty {
            components.append(currentComponent)
        }
        
        // Start with the first time value
        var runningTotalSeconds: TimeInterval = 0
        
        // Process first time without operator
        if !components.isEmpty {
            runningTotalSeconds = timeStringToSeconds(components[0])
        }
        
        // Process remaining components with their operators
        for i in 0..<operations.count {
            if i < components.count - 1 {
                let timeValue = timeStringToSeconds(components[i+1])
                if operations[i] == "+" {
                    runningTotalSeconds += timeValue
                } else {
                    runningTotalSeconds -= timeValue
                }
            }
        }
        
        // Convert the final result back to time string
        return formatTimeInterval(runningTotalSeconds)
    }

    // Helper function to convert time string (HH:MM) to seconds
    func timeStringToSeconds(_ timeString: String) -> TimeInterval {
        let components = timeString.split(separator: ":")
        if components.count == 2,
           let hours = Int(components[0]),
           let minutes = Int(components[1]) {
            return TimeInterval(hours * 3600 + minutes * 60)
        }
        return 0
    }

    // Helper function to format seconds as HH:MM
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalMinutes = Int(abs(interval) / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = interval < 0 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, hours, minutes)
    }

}

#Preview {
    ContentView()
}
