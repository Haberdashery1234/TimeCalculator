//
//  CalculatorPreviewView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct CalculatorPreviewView: View {
    @Environment(ThemeManager.self) var themeManager
    
    let scale: CGFloat
    
    // Sample data for preview
    let displayValue = "01:30 + 00:45"
    let resultValue = "02:15"
    
    var body: some View {
        CalculatorView(theme: themeManager.currentTheme, scale: scale)
            .allowsHitTesting(false)
    }
}

#Preview {
    CalculatorPreviewView(scale: 1)
        .environment(ThemeManager())
}
