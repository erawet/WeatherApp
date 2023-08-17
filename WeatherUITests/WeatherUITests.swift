//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Don E Wettasinghe on 8/15/23.
//

import XCTest

final class WeatherUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()

    }

    override func tearDownWithError() throws {
     
    }
    
    func testSearchLocation () throws {
        app.launch()
        
        let app = XCUIApplication()
        app.textFields["Search"].tap()
        app.textFields["Search"].typeText("Rockville")
        app.buttons["searchBtn"].tap()
        // check correct city listed
        XCTAssertTrue(app.staticTexts["Rockville"].exists)
    }
    
    func testSearchLocationWithCountryCode () throws {
        app.launch()
        
        let app = XCUIApplication()
        app.textFields["Search"].tap()
        app.textFields["Search"].typeText("Berlin,0049")
        app.buttons["searchBtn"].tap()
        sleep(5)
        // check correct city listed
        XCTAssertTrue(app.staticTexts["Berlin"].exists)
    }
    
}
