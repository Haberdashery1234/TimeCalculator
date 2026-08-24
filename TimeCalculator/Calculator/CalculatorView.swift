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
            // Header
            Text("Time Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            // Display
            VStack(alignment: .trailing) {
                Text(viewModel.expression + viewModel.displayText)
                    .font(.system(size: 60, weight: .light))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(viewModel.resultText)
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
    }
}

#Preview {
    CalculatorView()
}
