//
//  ContentView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct CalculatorView: View {
    @State private var viewModel = ViewModel()
    @State var theme: ColorTheme
    
    let scale: CGFloat
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 20) {            
            // Display
            VStack(alignment: .trailing) {
                Text(viewModel.fullCalculation + "\(viewModel.displayText)")
                    .font(.system(size: 60, weight: .light))
                    .foregroundStyle(theme.displayTextColor)
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(viewModel.result)
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(theme.resultTextColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel("Total Time")
                    .accessibilityValue("Total Time: \(viewModel.result)")
                    .accessibilityIdentifier("Total Time")
            }
            .padding()
            .background(theme.displayBackgroundColor)
            .cornerRadius(15)
            .padding(.horizontal)
            .accessibilityElement(children: .contain)
            
            ButtonsView(
                theme: theme,
                scale: scale,
                onDigitPress: viewModel.appendDigit,
                onDoubleZeroPress: viewModel.appendDoubleZero,
                onClear: viewModel.clearAll,
                onAddition: { viewModel.performOperation("+") },
                onSubtraction: { viewModel.performOperation("-") },
                onEquals: viewModel.calculate,
                onDelete: viewModel.backspace
            )
            .accessibilityElement(children: .contain)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(theme.backgroundColor)
        .preferredColorScheme(theme.isDarkTheme ? .dark : .light)
        .accessibilityIdentifier("Calculator View")
    }
}

#Preview {
    CalculatorView(theme: ColorTheme.light, scale: 1.0)
}
