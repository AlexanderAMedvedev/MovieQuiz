//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 07.05.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    let resultsViewModel: QuizResultsViewModel
    var alertSome: AlertViewModel
    
    func prepareAlert() {
        //1) Создание для алерта
        //  объектов
        let alert = UIAlertController(
            title: alertSome.title,     // заголовок всплывающего окна
            message: alertSome.message, // текст во всплывающем окне
            preferredStyle: .alert      // preferredStyle может быть .alert или .actionSheet
        )
        //  кнопки с действием
        let action = UIAlertAction(title: alertSome.buttonText,
                                   style: .default
        ){ _ in
            // распаковка опционала
            guard let delegate = self.delegate else { return }
            // код, который сбрасывает игру и показывает первый вопрос
            delegate.correctAnswers =  0
            delegate.currentQuestionIndex = 0
            delegate.questionFactory?.requestNextQuestion()
        }
        //  присутствия кнопки
        alert.addAction(action)
        //2) Передача подготовленного алерта делегату
        delegate?.showAlert(alert: alert, completion: alertSome.completion)
    }
    
    init(delegate: AlertPresenterDelegate,
         resultsViewModel: QuizResultsViewModel
    ) {
        self.delegate = delegate
        self.resultsViewModel = resultsViewModel
        self.alertSome = AlertViewModel(title: resultsViewModel.title,
                                    message: resultsViewModel.text,
                                    buttonText: resultsViewModel.buttonText
        )
    }
}
