//
//  TimeCalculatorApp.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/9/25.
//

import SwiftUI
import SwiftData

@main
struct TimeCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: TimeCardEntry.self)
    }
}
