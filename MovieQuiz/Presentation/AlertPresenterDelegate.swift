//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 07.05.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    var correctAnswers: Int { get set }
    var currentQuestionIndex: Int { get set }
    var questionFactory: QuestionFactoryProtocol? { get }
    func showAlert(alert: UIAlertController,
                   completion: (() -> Void)?
    )
}
