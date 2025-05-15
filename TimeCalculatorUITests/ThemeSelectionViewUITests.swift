//
//  ThemeSelectionViewUITests.swift
//  TimeCalculatorUITests
//
//  Created by Christian Grise on 5/7/25.
//

import XCTest

final class ThemeSelectionViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_chooseTheme() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Settings"].tap()
        XCTAssert(app.navigationBars["Settings"].exists)
        
        app.buttons["ChooseTheme"].tap()
        XCTAssert(app.staticTexts["Choose a theme"].exists)
        
        app.buttons["DarkThemeButton"].tap()
        XCTAssert(app.navigationBars["Settings"].exists)
    }
}
