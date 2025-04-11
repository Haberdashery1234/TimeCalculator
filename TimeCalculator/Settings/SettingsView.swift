//
//  SettingsView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) var themeManager
    
    // Display Settings
    @AppStorage("use24HourFormat") private var use24HourFormat = true
    @AppStorage("themeMode") private var themeMode = "system"
    @AppStorage("buttonSize") private var buttonSize = "standard"
    
    // Input Methods
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("soundEffects") private var soundEffects = false
    
    // History & Data
    @AppStorage("saveHistory") private var saveHistory = true
    @AppStorage("historyRetention") private var historyRetention = "30days"
    
    // Accessibility
    @AppStorage("highContrastMode") private var highContrastMode = false
    @AppStorage("largeFontSize") private var largeFontSize = false
    
    // Available options for selections
    let themeModeOptions = ["light", "dark", "system"]
    let buttonSizeOptions = ["compact", "standard", "large"]
    
    let historyRetentionOptions = ["1 day", "7 days", "30 days", "90 days", "forever"]
    
    var body: some View {
        NavigationView {
            Form {
                // Display Section
                Section(header: Text("Display")) {
                    Toggle("24-Hour Format", isOn: $use24HourFormat)
                    
                    Picker("Button Size", selection: $buttonSize) {
                        ForEach(buttonSizeOptions, id: \.self) { size in
                            Text(size.capitalized).tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Themes")) {
                    ForEach(themeManager.availableThemes) { theme in
                        HStack {
                            Circle()
                                .fill(theme.accentColor)
                                .frame(width: 20, height: 20)
                            Text(theme.name)
                            Spacer()
                            if themeManager.currentTheme.id == theme.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            themeManager.setTheme(theme)
                        }
                    }
                    
                    NavigationLink("Create New Theme") {
                        ThemeEditorView()
                            .environment(themeManager)
                    }
                }
                
                // Input Methods Section
                Section(header: Text("Input")) {
                    
                    Toggle("Haptic Feedback", isOn: $hapticFeedback)
                    
                    Toggle("Sound Effects", isOn: $soundEffects)
                }
                
                // History & Data Section
                Section(header: Text("History & Data")) {
                    Toggle("Save Calculation History", isOn: $saveHistory)
                    
                    if saveHistory {
                        Picker("History Retention", selection: $historyRetention) {
                            ForEach(historyRetentionOptions, id: \.self) { period in
                                Text(period.capitalized).tag(period.lowercased().replacingOccurrences(of: " ", with: ""))
                            }
                        }
                        
                        Button("Export History") {
                            // Export functionality would go here
                        }
                        
                        Button("Clear History") {
                            // Clear history functionality would go here
                        }
                        .foregroundColor(.red)
                    }
                }
                
                // Accessibility Section
                Section(header: Text("Accessibility")) {
                    Toggle("High Contrast Mode", isOn: $highContrastMode)
                    
                    Toggle("Large Text", isOn: $largeFontSize)
                }
                
                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Button("Rate the App") {
                        // App store rating functionality
                    }
                    
                    Button("Send Feedback") {
                        // Feedback functionality
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}


#Preview {
    SettingsView()
}
