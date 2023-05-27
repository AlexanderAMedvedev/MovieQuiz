//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Александр Медведев on 25.05.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz
final class MockMovieQuizViewController: PresenterUseViewController {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func frameHighlight(_ firstColor: Bool) {
    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
    }
    
    func showLoadingIndicator(parameter: Bool) {
    }
    
    func showNetworkError(message: String) {
    }
}
final class MovieQuizPresenterTests: XCTestCase {
    func testMovieQuizPresenterConvertFunc() throws {
        let viewController = MockMovieQuizViewController()
        let presenter = MovieQuizPresenter(viewController: viewController)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
