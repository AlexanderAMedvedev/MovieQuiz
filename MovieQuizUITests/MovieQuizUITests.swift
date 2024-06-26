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
    
    func testYesButton() {
        sleep(3)

        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let firstIndexLabel = app.staticTexts["Index"]
        XCTAssertEqual(firstIndexLabel.label, "1/10")
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        sleep(3)

        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let secondIndexLabel = app.staticTexts["Index"]
        XCTAssertEqual(secondIndexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        sleep(3)

        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let firstIndexLabel = app.staticTexts["Index"]
        XCTAssertEqual(firstIndexLabel.label, "1/10")
        
        app.buttons["No"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let secondIndexLabel = app.staticTexts["Index"]
        XCTAssertEqual(secondIndexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testEndQuizAlert() {
//1 Как указать id алёрта, который получаем в конце игры?
        var i: Int = 1
        sleep(3)
        while i <= 10 {
            app.buttons["No"].tap()
            i += 1
            sleep(3)
        }
      
        let alert = app.alerts["Этот раунд окончен!"]
        let  titleAlert = alert.label
        let  buttonTextAlert = alert.buttons.firstMatch.label
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(titleAlert,"Этот раунд окончен!")
        XCTAssertEqual(buttonTextAlert, "Сыграть ещё раз")
    }
    
    func testStartSecondQuiz() {
        var i: Int = 1
        sleep(3)
        while i <= 10 {
            app.buttons["No"].tap()
            i += 1
            sleep(3)
        }
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        let poster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(poster.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
