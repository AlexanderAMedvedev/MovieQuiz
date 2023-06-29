//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 24.05.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    //Additional commands
    // 1)Only for finding the path to sandBox: statistics?.printSandBox()
    //Questions
    // 1) Почему `showAnswerResult` это метод-приложение?
    var questionFactory: QuestionFactoryProtocol?
    private let statistics: StatisticsService!
    private weak var viewController: PresenterUseViewController?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0 
    var correctAnswers: Int = 0
    
    init(viewController: PresenterUseViewController) {
        self.viewController = viewController
        statistics = StatisticsServiceImplementation()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        viewController.showLoadingIndicator(parameter: false)
        questionFactory?.loadData()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    // func convert - SHOULD BE PRIVATE (deleted `private` due to `MovieQuizPresenterTests`)
    // search by Find navigator of `convert` within the project showed, that I can delete this `private`
    func convert(model: QuizQuestion) -> QuizStepViewModel { // Конвертация вопроса в ViewModel
        let questionStep = QuizStepViewModel(
              image: UIImage(data: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return questionStep
    }
    private func didAnswer(isYes: Bool) {
        let userAnswer: Bool = isYes
        guard let currentQuestion = currentQuestion else {
            return }
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            viewController?.frameHighlight(isCorrect)
        } else {
            viewController?.frameHighlight(isCorrect)
        }
        // через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
     func showNextQuestionOrResults() {
        if self.isLastQuestion() {
// Предварительная подготовка параметров модели "QuizResultsViewModel"
            guard let statistics = statistics else {
                print("statistics object error")
                return}
            
            let currentGame = GameRecord(correct: correctAnswers, total: self.questionsAmount, date: Date())
            statistics.setBestGame(currentGame)
          
            let bestGame = statistics.bestGame
            let record: String = "\(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        
            statistics.store(totalCurrent: self.questionsAmount, correctCurrent: correctAnswers)
            
            let averageAccuracy = String(format: "%.2f", statistics.totalAccuracy)

            let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: """
                          Ваш результат: \(correctAnswers)/\(self.questionsAmount)
                          Количество сыгранных квизов: \(statistics.gamesCount)
                          Рекорд: \(record)
                          Средняя точность: \(averageAccuracy)%
                        """,
                    buttonText: "Сыграть ещё раз"
            )
      
            viewController?.show(quiz: result)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func didLoadDataFromServer() {
        viewController?.showLoadingIndicator(parameter: true) // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription) //localizedDescription - Retrieve(Извлекать) the localized description for this error.
    }
}
