//
//  ContentView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct CalculatorView: View {
    @Environment(ThemeManager.self) var themeManager
    @State private var viewModel = ViewModel()
    
    let scale: CGFloat
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 20) {            
            // Display
            VStack(alignment: .trailing) {
                Text(viewModel.fullCalculation + "\(viewModel.displayText)")
                    .font(.system(size: 60, weight: .light))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(viewModel.result)
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
                scale: scale,
                onDigitPress: viewModel.appendDigit,
                onDoubleZeroPress: viewModel.appendDoubleZero,
                onClear: viewModel.clearAll,
                onAddition: { viewModel.performOperation("+") },
                onSubtraction: { viewModel.performOperation("-") },
                onEquals: viewModel.calculate,
                onDelete: viewModel.backspace
            )
        }
        .padding()
        .environment(themeManager)
    }
}

#Preview {
    CalculatorView(scale: 1.0)
        .environment(ThemeManager())
}
