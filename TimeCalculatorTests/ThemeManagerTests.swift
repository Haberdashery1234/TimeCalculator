//
//  ThemeManagerTests.swift
//  TimeCalculatorTests
//
//  Created by Christian Grise on 5/6/25.
//

import Testing
import SwiftUI

struct ThemeManagerTests {

    @Test func test_init() async throws {
        let manager = ThemeManager()
        
        manager.setTheme(.light)
        #expect(manager.currentTheme == .light)
        #expect(manager.availableThemes.count > 0)
    }
    
    @Test func test_addTheme() async throws {
        let manager = ThemeManager()
        #expect(manager.availableThemes.count == 2)
        manager.addTheme(ColorTheme.testTheme)
        #expect(manager.availableThemes.count == 3)
    }
    
    @Test func test_updateTheme() async throws {
        let manager = ThemeManager()
        manager.setTheme(ColorTheme.testTheme)
        
        let newColor = Color(red: 0.92, green: 0.92, blue: 0.94)
        var theme = manager.currentTheme
        theme.backgroundColor = newColor
        manager.updateTheme(theme)
        #expect(manager.currentTheme.backgroundColor == newColor)
    }
    
    @Test func test_deleteTheme() async throws {
        let manager = ThemeManager()
        #expect(manager.availableThemes.count == 2)
        manager.addTheme(ColorTheme.testTheme)
        #expect(manager.availableThemes.count == 3)
        manager.deleteTheme(ColorTheme.testTheme)
        #expect(manager.availableThemes.count == 2)
    }
    
    @Test func test_setTheme() async throws {
        let manager = ThemeManager()
        #expect(manager.currentTheme == ColorTheme.light)
        manager.setTheme(ColorTheme.dark)
        #expect(manager.currentTheme == ColorTheme.dark)
    }
}
