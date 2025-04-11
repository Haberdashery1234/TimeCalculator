//
//  ThemeManager.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import Foundation

@Observable
class ThemeManager {
    var currentTheme: ColorTheme
    var availableThemes: [ColorTheme]
    
    init() {
        self.currentTheme = ColorTheme.light
        self.availableThemes = [.light, .dark, .blue]
        // Load saved/custom themes here
    }
    
    func addTheme(_ theme: ColorTheme) {
        availableThemes.append(theme)
        // Save to storage
    }
    
    func deleteTheme(_ theme: ColorTheme) {
        availableThemes.removeAll { $0.id == theme.id }
        // Update storage
    }
}
