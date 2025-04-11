//
//  CalculatorPreviewView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct CalculatorPreviewView: View {
    let themeManager: ThemeManager
    let scale: CGFloat
    
    // Sample data for preview
    let displayValue = "01:30 + 00:45"
    let resultValue = "02:15"
    
    var body: some View {
        CalculatorView(themeManager: themeManager, scale: scale)
            .allowsHitTesting(false) 
    }
}

#Preview {
    CalculatorPreviewView(themeManager: ThemeManager(), scale: 1)
}
