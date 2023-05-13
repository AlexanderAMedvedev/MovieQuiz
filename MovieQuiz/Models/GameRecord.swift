//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 10.05.2023.
//

import Foundation
/// Модель результата игры
struct GameRecord: Codable {
    //кол-во правильных ответов
    let correct: Int
    //кол-во вопросов квиза
    let total: Int
    //дата завершения квиза
    let date: Date
}
