//
//  CalculatorViewUITests.swift
//  TimeCalculatorUITests
//
//  Created by Christian Grise on 5/6/25.
//

import XCTest

final class CalculatorViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        app.tabBars.buttons["Calculator"].tap()
        XCTAssert(app.otherElements["Calculator View"].exists)
        
        app.buttons["number-1"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 00:01")
        
        app.buttons["number-2"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 00:12")
        
        app.buttons["number-3"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 01:23")
        
        app.buttons["number-4"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 12:34")
        
        app.buttons["operation-add"].tap()
        app.buttons["number-1"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 12:35")
        
        app.buttons["number-00"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 13:34")
        
        app.buttons["function-delete"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 12:44")
        
        app.buttons["number-0"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 13:34")
        
        app.buttons["operation-equal"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 13:34")
        
        app.buttons["function-clear"].tap()
        XCTAssert(app.staticTexts["Total Time"].value as! String == "Total Time: 00:00")
    }
}
