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
    var alertSome: AlertViewModel
    
    init(
        delegate: AlertPresenterDelegate,
        alertSome: AlertViewModel
    ) {
        self.delegate = delegate
        self.alertSome = alertSome
    }
    
    func show() {
        //1) Создание для алерта
        //  объектов
        let alert = UIAlertController(
            title: alertSome.title,     // заголовок всплывающего окна
            message: alertSome.message, // текст во всплывающем окне
            preferredStyle: .alert      // preferredStyle может быть .alert или .actionSheet
        )
        //  кнопки с действием
        let action = UIAlertAction(
                                   title: alertSome.buttonText,
                                   style: .default,
                                   handler: alertSome.handler
                                   ) 
        //  присутствия кнопки
        alert.addAction(action)
        //2) Передача подготовленного алерта делегату
        delegate?.showAlert(alert: alert, completion: nil)
    }
}
