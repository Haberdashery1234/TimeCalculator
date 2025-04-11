//
//  ButtonsView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

struct ButtonsView: View {
    @Environment(ThemeManager.self) private var themeManager
    
    var onDigitPress: (Int) -> Void
    var onDoubleZeroPress: () -> Void
    var onClear: () -> Void
    var onAddition: () -> Void
    var onSubtraction: () -> Void
    var onEquals: () -> Void
    var onDelete: () -> Void
    
    var scale: CGFloat
    
    init(
        scale: CGFloat,
        onDigitPress: @escaping (Int) -> Void = { _ in },
        onDoubleZeroPress: @escaping () -> Void = {},
        onClear: @escaping () -> Void = {},
        onAddition: @escaping () -> Void = {},
        onSubtraction: @escaping () -> Void = {},
        onEquals: @escaping () -> Void = {},
        onDelete: @escaping () -> Void = {}
    ) {
        self.scale = scale
        self.onDigitPress = onDigitPress
        self.onDoubleZeroPress = onDoubleZeroPress
        self.onClear = onClear
        self.onAddition = onAddition
        self.onSubtraction = onSubtraction
        self.onEquals = onEquals
        self.onDelete = onDelete
    }
    
    var body: some View {
        // Buttons
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("7") { onDigitPress(7) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("8") { onDigitPress(8) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("9") { onDigitPress(9) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("C") { onClear() }
                    .buttonStyle(FunctionButtonStyle(theme: themeManager.currentTheme, scale: scale))
            }
            
            // Third row
            HStack(spacing: 12) {
                Button("4") { onDigitPress(4) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("5") { onDigitPress(5) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("6") { onDigitPress(6) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("−") {
                    onSubtraction()
                }
                .buttonStyle(OperationButtonStyle(theme: themeManager.currentTheme, scale: scale))
            }
            
            // Fourth row
            HStack(spacing: 12) {
                Button("1") { onDigitPress(1) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("2") { onDigitPress(2) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("3") { onDigitPress(3) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("+") {
                    onAddition()
                }
                .buttonStyle(OperationButtonStyle(theme: themeManager.currentTheme, scale: scale))
            }
            
            // Fifth row
            HStack(spacing: 12) {
                
                Button("0") { onDigitPress(0) }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("00") { onDoubleZeroPress() }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button(action: { onDelete() }) {
                    Image(systemName: "delete.left")
                }
                    .buttonStyle(NumberButtonStyle(theme: themeManager.currentTheme, scale: scale))
                
                Button("=") {
                    onEquals()
                }
                .buttonStyle(OperationButtonStyle(theme: themeManager.currentTheme, scale: scale))
            }
        }
        .padding()
    }
}

// MARK: - Button Styles

struct NumberButtonStyle: ButtonStyle {
    let theme: ColorTheme
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 36 * scale))
            .frame(width: 70 * scale, height: 70 * scale)
            .background(theme.numberButtonColor)
            .foregroundColor(theme.numberTextColor)
            .cornerRadius(theme.buttonCornerRadius * scale)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct FunctionButtonStyle: ButtonStyle {
    let theme: ColorTheme
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 36 * scale))
            .frame(width: 70 * scale, height: 70 * scale)
            .background(theme.functionButtonColor)
            .foregroundColor(theme.functionTextColor)
            .cornerRadius(theme.buttonCornerRadius * scale)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct OperationButtonStyle: ButtonStyle {
    let theme: ColorTheme
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 36 * scale))
            .frame(width: 70 * scale, height: 70 * scale)
            .background(theme.operationButtonColor)
            .foregroundColor(theme.operationTextColor)
            .cornerRadius(theme.buttonCornerRadius * scale)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    ButtonsView(scale: 1)
        .environment(ThemeManager())
}
