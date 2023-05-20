//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Александр Медведев on 20.05.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication! //`class XCUIApplication: XCUIElement` - A proxy(уполномоченный) that can launch, monitor, and terminate a test application.//!-implicitly unwrapped optional
    override func setUpWithError() throws {// setUp - помещать|is called before the invocation of each test method in the class
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {//tear down - срывать|is called after the invocation of each test method in the class
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }
    
    func testScreenCast() throws {
        
        app.buttons["Нет"].tap() //@NSCopying var buttons: XCUIElementQuery { get } - A query(запрос) that matches(приводить в соответстве) button control elements.

                
    }//Cast-муляж
    
    /*func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }*/

   /* func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    } */
}
