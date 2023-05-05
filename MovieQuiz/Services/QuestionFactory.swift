//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 04.05.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let questions: [QuizQuestion] = [
     QuizQuestion(
      image: "The Godfather",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9,2
      correctAnswer: true),
     QuizQuestion(
      image: "The Dark Knight",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9
      correctAnswer: true),
     QuizQuestion(
      image: "Kill Bill",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8,1
      correctAnswer: true),
     QuizQuestion(
      image: "The Avengers",
      text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8
      correctAnswer: true),
    QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 8
     correctAnswer: true),
    QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 6,6
     correctAnswer: true),
    QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,8
     correctAnswer: false),
    QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 4,3
     correctAnswer: false),
    QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,1
     correctAnswer: false),
    QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",//Настоящий рейтинг: 5,8
     correctAnswer: false)
    ]// конец массива вопросов
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
}
