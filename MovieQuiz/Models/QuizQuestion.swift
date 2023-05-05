//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 04.05.2023.
//

import Foundation

 struct QuizQuestion {
  let image: String // строка с названием фильма, совпадает с названием картинки афиши фильма в Assets
  let text: String // строка с вопросом о рейтинге фильма
  let correctAnswer: Bool // булевое значение (true, false), правильный ответ на вопрос
}
