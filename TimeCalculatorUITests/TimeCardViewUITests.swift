//
//  AddTimeCardEntryViewUITests.swift
//  TimeCalculatorUITests
//
//  Created by Christian Grise on 5/6/25.
//

import XCTest

final class TimeCardViewUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["isRunningUITests"]
        app.launch()
        
        app.tabBars.buttons["Time Card"].tap()
        XCTAssert(app.staticTexts["Time Card"].exists)
    }

    override func tearDownWithError() throws {
        
    }

    func test_populateData() throws {

        app.buttons["AddEntryButton"].tap()
        XCTAssert(app.datePickers["DateDatePicker"].exists)
        
        app.buttons["setValidDateButton"].tap()
        app.buttons["AddButton"].tap()
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: tomorrow)!
        
        let dateString = DateFormatter.localizedString(from: noon, dateStyle: .medium, timeStyle: .none)
        let timeString = DateFormatter.localizedString(from: noon, dateStyle: .none, timeStyle: .short) + "-" + DateFormatter.localizedString(from: noon.addingTimeInterval(3600), dateStyle: .none, timeStyle: .short)
        
        XCTAssert(app.staticTexts["\(dateString)"].exists)
        XCTAssert(app.staticTexts["\(timeString)"].exists)
    }
}
