//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 10.05.2023.
//
// questions
//1 why we type rawvalue in the code:
// 'guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue)'
//2 Does the initializer of the class need smth if I have `get` and `set`  for each property?
//3 Can I place `else` on the next line in `guard let` construction?
import Foundation

protocol StatisticsService {
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var totalAccuracy: Double { get }
    
    func setBestGame(_ newGameRecord: GameRecord)
    // учёт результата текущей игры для двух величин
    func store(totalCurrent: Int, correctCurrent: Int)
    //to have the path to the sandBox
    func printSandBox()
}
final class StatisticsServiceImplementation: StatisticsService {
    //UserDefaults - интерфейс к базе данных, содержащей  настройки пользователя, установленные "по умолчанию"
    //standard - возвращает объект "shared defaults"
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case gamesCount, bestGame, total, totalCorrect
    }
    var gamesCount: Int {
        get {
            var value = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
               value += 1
               userDefaults.set(value, forKey: Keys.gamesCount.rawValue)
               return value
            }
    }
  
    var bestGame: GameRecord {
        get {// установка значения поля класса при обращении к нему
                  // 1 попробовать извлечь данные, соответствующе ключу
                     // 1 userDefaults.data(forKey: Keys.bestGame.rawValue) - метод, возвращающий объект данных ассоциированный с указанным ключом
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  // 2 попробовать записать экземпляр структуры в результате декодирования данных
                     // 1 JSONDecoder().decode(GameRecord.self, from: data) - метод, возвращающий объект указанного типа, полученный в результате декодирования объекта формата JSON
                        // 1 JSONDecoder() - объект, декодирующий образцы типа data (например, типа структуры, реализованной программистом) из объектов в формате JSON
                        // 2 decode(GameRecord.self, from: data) - возвращает значение указанного типа, полученное в результате декодирования объекта в формате JSON
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            // изменения значения свойства класса на то, которое указывает пользователь
               // 1 JSONEncoder() - объект, кодирующий данные типа Data (тип Data - промежуточное хранилище информации в байтах)
               // 2 encode - возвращает JSON-закодированные данные из указанных данных
               // 3 try - ключевое слово, используемое перед функцией, методом, инициализатором, которые могут выкинуть (throw) ошибку
            guard let jsonData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            // set - установка указанного значения для указанного ключа
            userDefaults.set(jsonData, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        get {
            //1 найти общее кол-во ответов
            let total = userDefaults.integer(forKey: Keys.total.rawValue)
            //2 найти общее кол-во правильных ответов
            let totalCorrect = userDefaults.integer(forKey: Keys.totalCorrect.rawValue)
            //3 вернуть значение totalAccuracy
            return Double(totalCorrect)/Double(total)*Double(100)
        }
    }
    // результат сравнения количества правильных ответов в двух играх
     func setBestGame(_ newGameRecord: GameRecord) {
         if  newGameRecord.correct >= self.bestGame.correct {
             bestGame = newGameRecord
         }
    }
    
    func store(totalCurrent: Int, correctCurrent: Int) {
        //сохранить значение общего кол-ва ответов
         //увеличить хранимое значение на totalCurrent
          //извлечь хранимое значение
        var totalStored = userDefaults.integer(forKey: Keys.total.rawValue)
          //прибавить к нему totalCurrent
        totalStored += totalCurrent
         //сохранить новое значение
        userDefaults.set(totalStored, forKey: Keys.total.rawValue)
        //сохранить значение общего кол-ва правильных ответов
         //увеличить хранимое значение на correctCurrent
          //извлечь хранимое значение
        var totalCorrectStored = userDefaults.integer(forKey: Keys.totalCorrect.rawValue)
          //прибавить к нему correctCurrent
        totalCorrectStored += correctCurrent
         //сохранить новое значение
        userDefaults.set(totalCorrectStored, forKey: Keys.totalCorrect.rawValue)
    }
    func printSandBox() { print(NSHomeDirectory()) }
}
