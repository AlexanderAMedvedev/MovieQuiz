//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 24.05.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    weak var viewController: MovieQuizViewController?
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0 // переменная с индексом текущего вопроса

    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
            currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
            currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel { // Конвертация вопроса в ViewModel
        let questionStep = QuizStepViewModel(
              image: UIImage(data: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return questionStep
    }
    func noButtonClicked() {
        let userAnswer: Bool = false
        guard let currentQuestion = currentQuestion else {
            return }
        
        viewController?.showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
        return }
        let userAnswer: Bool = true
        
        viewController?.showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}
