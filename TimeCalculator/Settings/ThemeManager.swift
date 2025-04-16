//
//  ThemeManager.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

// Create a separate class for storage that does NOT use @Observable
class ThemeStorage {
    @AppStorage("theme.currentId") var currentThemeId: String = ColorTheme.light.id
    @AppStorage("theme.data") var themesData: Data = Data()
    
    // Simple accessors
    func saveCurrentThemeId(_ id: String) {
        currentThemeId = id
    }
    
    func saveThemesData(_ data: Data) {
        themesData = data
    }
}

@Observable
class ThemeManager {
    // Regular stored properties without property wrappers
    private(set) var currentTheme: ColorTheme
    private(set) var availableThemes: [ColorTheme]
    
    // Storage handler - no property wrapper conflicts
    private let storage = ThemeStorage()
    
    init() {
        // Set defaults first
        self.currentTheme = ColorTheme.dark
        self.availableThemes = [.light, .dark, .blue]
        
        // Then load from storage
        loadFromStorage()
    }
    
    private func loadFromStorage() {
        // Load themes
        if let decoded = try? JSONDecoder().decode([ColorTheme].self, from: storage.themesData),
           !decoded.isEmpty {
//            self.availableThemes = decoded
        } else {
            // Save defaults if nothing found
            saveThemes()
        }
        
        // Load current theme
        if let theme = availableThemes.first(where: { $0.id == storage.currentThemeId }) {
            self.currentTheme = theme
        } else {
            // Reset to default if not found
            self.currentTheme = ColorTheme.light
            storage.saveCurrentThemeId(ColorTheme.light.id)
        }
    }
    
    func addTheme(_ theme: ColorTheme) {
        if !availableThemes.contains(where: { $0.id == theme.id }) {
            availableThemes.append(theme)
            saveThemes()
        }
    }
    
    func updateTheme(_ updatedTheme: ColorTheme) {
        if let index = availableThemes.firstIndex(where: { $0.id == updatedTheme.id }) {
            availableThemes[index] = updatedTheme
            
            if currentTheme.id == updatedTheme.id {
                currentTheme = updatedTheme
            }
            
            saveThemes()
        }
    }
    
    func deleteTheme(_ theme: ColorTheme) {
        // Protect current theme and default themes
        guard theme.id != currentTheme.id else { return }
        
        let isBaseTheme = [ColorTheme.light.id, ColorTheme.dark.id, ColorTheme.blue.id].contains(theme.id)
        if !isBaseTheme {
            availableThemes.removeAll { $0.id == theme.id }
            saveThemes()
        }
    }
    
    func setTheme(_ theme: ColorTheme) {
        if availableThemes.contains(where: { $0.id == theme.id }) {
            currentTheme = theme
            storage.saveCurrentThemeId(theme.id)
        } else {
            addTheme(theme)
            currentTheme = theme
            storage.saveCurrentThemeId(theme.id)
        }
    }
    
    private func saveThemes() {
        if let data = try? JSONEncoder().encode(availableThemes) {
            storage.saveThemesData(data)
        }
    }
}
