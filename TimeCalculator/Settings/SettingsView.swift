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
    
    @State private var isShowingThemePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                // Display Section
                Section(header: Text("Display")) {
                    Toggle("24-Hour Format", isOn: $use24HourFormat)
                        .tint(themeManager.currentTheme.accentColor)
                    
                    Picker("Button Size", selection: $buttonSize) {
                        ForEach(buttonSizeOptions, id: \.self) { size in
                            Text(size.capitalized).tag(size)
                                .foregroundStyle(themeManager.currentTheme.displayTextColor)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(themeManager.currentTheme.textColor)], for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(themeManager.currentTheme.textColor)], for: .selected)
                    }
                }
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
                
                Section(header: Text("Themes")) {
                    HStack {
                        Text("Current Theme: ")
                        Text(themeManager.currentTheme.name)
                            .foregroundColor(themeManager.currentTheme.textColor)
                    }
                    Button {
                        isShowingThemePicker = true
                    } label: {
                        Text("Choose a theme")
                    }

                }
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
                
                // Input Methods Section
                Section(header: Text("Input")) {
                    Toggle("Haptic Feedback", isOn: $hapticFeedback)
                        .tint(themeManager.currentTheme.accentColor)
                    
                    Toggle("Sound Effects", isOn: $soundEffects)
                }
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
                
                // History & Data Section
                Section(header: Text("History & Data")) {
                    Toggle("Save Calculation History", isOn: $saveHistory)
                        .tint(themeManager.currentTheme.accentColor)
                    
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
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
                
                // Accessibility Section
                Section(header: Text("Accessibility")) {
                    Toggle("High Contrast Mode", isOn: $highContrastMode)
                        .tint(themeManager.currentTheme.accentColor)
                    
                    Toggle("Large Text", isOn: $largeFontSize)
                        .tint(themeManager.currentTheme.accentColor)
                }
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
                
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
                .listRowBackground(themeManager.currentTheme.displayBackgroundColor)
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $isShowingThemePicker) {
                ThemeSelectionView()
                    .environment(themeManager)
            }
            .scrollContentBackground(.hidden)
            .background(themeManager.currentTheme.backgroundColor)
            .foregroundColor(themeManager.currentTheme.textColor)
            .accentColor(themeManager.currentTheme.accentColor)
            .onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: themeManager.currentTheme.textColor]
            }
        }
    }
}


#Preview {
    SettingsView()
        .environment(ThemeManager())
}
