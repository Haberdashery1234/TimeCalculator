//
//  TimeCalculatorApp.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI

@main
struct TimeCalculatorApp: App {
    @State private var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(themeManager)
        }
    }
}
