//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 04.05.2023.
//

//import Foundation
import UIKit
/// ViewModel для состояния "Вопрос показан"
 struct QuizStepViewModel {
  let image: UIImage   // картинка с афишей фильма с типом UIImage
  let question: String // вопрос о рейтинге квиза
  let questionNumber: String // строка с порядковым номером этого вопроса (ex. "1/10")
}
