//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 04.05.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
  /*
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
   */
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                let index = (0..<self.movies.count).randomElement() ?? 0
                guard let movie = self.movies[safe: index] else { return }
                
                var imageData = Data()
                do {
                    imageData = try Data(contentsOf: movie.imageURL)
                } catch {
                    print("Failed to load image")
                }
                
                let delimiter: Int = 9
                let text = "Рейтинг этого фильма больше \(delimiter)?"
                guard let rating = Float(movie.rating) else {
                print("Can not convert movie.rating to Float type."); return }
                let correctAnswer = rating > Float(delimiter)
                let question = QuizQuestion(
                                            image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer
                                            )
                
                DispatchQueue.main.async { [weak self] in
                //class DispatchQueue : DispatchObject - An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
                //class var main: DispatchQueue { get } - The dispatch queue associated with the main thread of the current process.
                //async - Schedules a block asynchronously for execution and optionally associates it with a dispatch group.
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
        /* Case: Local data
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
        */
    }
    func loadData() {
        moviesLoader.loadMovies() {  [weak self] result in
            DispatchQueue.main.async  {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем Все фильмы в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем MovieQuizViewController
                }
            }
        }
    }
}
