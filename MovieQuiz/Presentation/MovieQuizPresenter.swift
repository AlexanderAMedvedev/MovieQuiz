//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 24.05.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
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
}
