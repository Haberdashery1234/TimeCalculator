//
//  CalculatorView_ViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import Foundation

extension CalculatorView {
    @Observable
    class ViewModel {
        // Dependencies
        private let calculationModel = CalculationModel()
        
        // Published properties for UI binding
        var enteredDigits: [Int] = []
        var displayText: String = "00:00"
        var fullCalculation: String = ""
        var result: String = "00:00"
        
        // MARK: - Public Methods
        
        func updateDisplays() {
            displayText = calculationModel.formatTimeFromDigits(enteredDigits)
            result = calculateRunningResult()
        }
        
        func appendDigit(_ digit: Int) {
            enteredDigits.append(digit)
            updateDisplays()
        }
        
        func appendDoubleZero() {
            enteredDigits.append(0)
            enteredDigits.append(0)
            updateDisplays()
        }
        
        func backspace() {
            if !enteredDigits.isEmpty {
                enteredDigits.removeLast()
                updateDisplays()
            }
        }
        
        func clearAll() {
            enteredDigits.removeAll()
            fullCalculation = ""
            result = "00:00"
            displayText = "00:00"
        }
        
        func performOperation(_ operation: String) {
            fullCalculation += displayText + " \(operation) "
            enteredDigits.removeAll()
            result = calculateRunningResult()
            displayText = "00:00"
        }
        
        func calculate() {
            displayText = calculateRunningResult()
            fullCalculation = ""
            enteredDigits.removeAll()
        }
        
        // MARK: - Private Methods
        
        private func calculateRunningResult() -> String {
            let expression = fullCalculation + displayText
            return calculationModel.calculateResult(from: expression)
        }
    }

}
