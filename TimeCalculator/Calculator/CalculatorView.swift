//
//  ContentView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct CalculatorView: View {
    // MARK: - ViewModel
    @State private var viewModel = CalculatorViewModel()
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Display
            VStack(alignment: .trailing, spacing: 8) {
                // Expression text
                Text(viewModel.expression + viewModel.displayText)
                    .font(.system(size: 60, weight: .light, design: .rounded))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("Current input: \(viewModel.displayText)")
                
                // Result text
                Text(viewModel.resultText)
                    .font(.system(size: 28, weight: .regular, design: .rounded))
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("Result: \(viewModel.resultText)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal)
            
            ButtonsView(
                onDigitPress: viewModel.appendDigit,
                onDoubleZeroPress: viewModel.appendDoubleZero,
                onClear: viewModel.clear,
                onAddition: { viewModel.performOperation("+") },
                onSubtraction: { viewModel.performOperation("-") },
                onEquals: viewModel.calculate,
                onDelete: viewModel.backspace
            )
        }
        .padding()
        .navigationTitle("Time Calculator")
        .navigationBarTitleDisplayMode(.inline)
        // Keyboard shortcuts for macOS/iPadOS
        .onKeyPress(.delete) { 
            viewModel.backspace()
            return .handled
        }
        .onKeyPress(.return) {
            viewModel.calculate()
            return .handled
        }
        .onKeyPress("=") {
            viewModel.calculate()
            return .handled
        }
        .onKeyPress("+") {
            viewModel.performOperation("+")
            return .handled
        }
        .onKeyPress("-") {
            viewModel.performOperation("-")
            return .handled
        }
        .onKeyPress("c") {
            viewModel.clear()
            return .handled
        }
        .onKeyPress("0") {
            viewModel.appendDigit(0)
            return .handled
        }
        .onKeyPress("1") {
            viewModel.appendDigit(1)
            return .handled
        }
        .onKeyPress("2") {
            viewModel.appendDigit(2)
            return .handled
        }
        .onKeyPress("3") {
            viewModel.appendDigit(3)
            return .handled
        }
        .onKeyPress("4") {
            viewModel.appendDigit(4)
            return .handled
        }
        .onKeyPress("5") {
            viewModel.appendDigit(5)
            return .handled
        }
        .onKeyPress("6") {
            viewModel.appendDigit(6)
            return .handled
        }
        .onKeyPress("7") {
            viewModel.appendDigit(7)
            return .handled
        }
        .onKeyPress("8") {
            viewModel.appendDigit(8)
            return .handled
        }
        .onKeyPress("9") {
            viewModel.appendDigit(9)
            return .handled
        }
    }
}

#Preview {
    CalculatorView()
}
