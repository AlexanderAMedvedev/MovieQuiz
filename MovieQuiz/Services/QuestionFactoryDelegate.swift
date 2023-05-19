//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 05.05.2023.
//

import Foundation
//why we need AnyObject
protocol QuestionFactoryDelegate: AnyObject {
                            // AnyObject - The protocol to which all classes implicitly conform.
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
                                     //Error - A type representing an error value that can be thrown.
}
