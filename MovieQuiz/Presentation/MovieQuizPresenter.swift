//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 24.05.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    var questionFactory: QuestionFactoryProtocol?
    private let statistics: StatisticsService!
    private weak var viewController: MovieQuizViewController?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0 // переменная с индексом текущего вопроса
    var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statistics = StatisticsServiceImplementation()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel { // Конвертация вопроса в ViewModel
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
    func showAnswerResult(isCorrect: Bool) {
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
        //переход в один из сценариев
        if self.isLastQuestion() {
// состояние "Результат квиза"
//1 Предварительная подготовка параметров модели "QuizResultsViewModel"
            //распаковка опционала, чтобы далее код был проще
            guard let statistics = statistics else {
                print("statistics object error")
                return}
         // 1 рекорд
          // 1 сохранение лучшей игры
              // 1 запись текущей игры
            let currentGame = GameRecord(correct: correctAnswers, total: self.questionsAmount, date: Date())
              // 2 запись лучшей игры на устройство
            statistics.setBestGame(currentGame)
          // 2 сам рекорд - запись о лучшей игре
            let record: String = """
                                 \(statistics.bestGame.correct)/\(statistics.bestGame.total) \
                                 (\(statistics.bestGame.date.dateTimeString))
                                 """
        //2 средняя точность
            //1 учесть в статистике по всем играм кол-во всех ответов, кол-во только правильных ответов, которые даны в последней игре
            statistics.store(totalCurrent: self.questionsAmount, correctCurrent: correctAnswers)
            //2 получить значение в виде, требуемом макетом
            let averageAccuracy = String(format: "%.2f", statistics.totalAccuracy)
//2 Создание объекта "QuizResultsViewModel"
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
//3 Показ объекта "QuizResultsViewModel" на экране
            viewController?.show(quiz: result)
        } else {
            //состояние "Следующий вопрос показан"
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
        viewController?.downloadMoviesIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
        //localizedDescription - Retrieve(Извлекать) the localized description for this error.
    }
}
