//
//  ButtonsView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct ButtonsView: View {
    let onDigitPress: (Int) -> Void
    let onDoubleZeroPress: () -> Void
    let onClear: () -> Void
    let onAddition: () -> Void
    let onSubtraction: () -> Void
    let onEquals: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        // Buttons
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("7") { onDigitPress(7) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("8") { onDigitPress(8) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("9") { onDigitPress(9) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("C") { onClear() }
                    .buttonStyle(FunctionButtonStyle())
            }
            
            // Third row
            HStack(spacing: 12) {
                Button("4") { onDigitPress(4) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("5") { onDigitPress(5) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("6") { onDigitPress(6) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("−") {
                    onSubtraction()
                }
                .buttonStyle(OperationButtonStyle())
            }
            
            // Fourth row
            HStack(spacing: 12) {
                Button("1") { onDigitPress(1) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("2") { onDigitPress(2) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("3") { onDigitPress(3) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("+") {
                    onAddition()
                }
                .buttonStyle(OperationButtonStyle())
            }
            
            // Fifth row
            HStack(spacing: 12) {
                
                Button("0") { onDigitPress(0) }
                    .buttonStyle(NumberButtonStyle())
                
                Button("00") { onDoubleZeroPress() }
                    .buttonStyle(NumberButtonStyle())
                
                Button(action: { onDelete() }) {
                    Image(systemName: "delete.left")
                }
                    .buttonStyle(NumberButtonStyle())
                
                Button("=") {
                    onEquals()
                }
                .buttonStyle(OperationButtonStyle())
            }
        }
        .padding()
    }
}

// MARK: - Button Styles

struct NumberButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(width: 70, height: 70)
            .background(Color(.systemGray5))
            .foregroundColor(.primary)
            .cornerRadius(35)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct FunctionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(width: 70, height: 70)
            .background(Color(.systemGray4))
            .foregroundColor(.primary)
            .cornerRadius(35)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct OperationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(width: 70, height: 70)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(35)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
