//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 05.05.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
