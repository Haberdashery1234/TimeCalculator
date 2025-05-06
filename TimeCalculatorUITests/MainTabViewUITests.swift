//
//  TabBarViewUITests.swift
//  TimeCalculatorUITests
//
//  Created by Christian Grise on 5/6/25.
//

import XCTest

final class MainTabViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Time Card"].tap()
        XCTAssert(app.staticTexts["Time Card"].exists)
        
        app.tabBars.buttons["Settings"].tap()
        XCTAssert(app.navigationBars["Settings"].exists)
        
        app.tabBars.buttons["Calculator"].tap()
        XCTAssert(app.otherElements["Calculator View"].exists)
    }
}
