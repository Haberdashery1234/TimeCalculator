//
//  TabView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(ThemeManager.self) var themeManager
    
    var body: some View {
        NavigationStack {
            TabView {
                CalculatorView(theme: themeManager.currentTheme, scale: 1.0)
                    .tabItem {
                        Image(systemName: "plusminus")
                        Text("Calculator")
                    }
                    .accessibilityLabel("Calculator View")
                    .accessibilityIdentifier("Calculator View")
                TimeCardView()
                    .environment(themeManager)
                    .tabItem {
                        Image(systemName: "tablecells")
                        Text("Time Card")
                    }
                    .accessibilityLabel("Time Card")
                    .accessibilityIdentifier("Time Card")
                SettingsView()
                    .environment(themeManager)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .accessibilityLabel("Settings")
                    .accessibilityIdentifier("Settings")
            }
        }
        .preferredColorScheme(themeManager.currentTheme.isDarkTheme ? .dark : .light)
    }
}

#Preview {
    MainTabView()
        .environment(ThemeManager())
}
