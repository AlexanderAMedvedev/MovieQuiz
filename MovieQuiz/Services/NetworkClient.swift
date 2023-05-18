//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 16.05.2023.
//

import Foundation

/// Отвечает за загрузку данных по URL
struct NetworkClient {
    //1 why we neeed `task.resume()` in the end?
    // A: Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
    //2 why we do not have in func fetch `return smth: URLSessionDataTask`?
    //3 which rawValue does enum `NetworkError: Error` have?
      //Networkclient - сетевой заказчик
    private enum NetworkError: Error {
        case codeError
    }
    //получить
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // A closure is said to escape a function when the closure is passed as an argument to the function,
        // but is called after the function returns.
        //URLRequest - A URL load request that is independent of protocol or URL scheme.
        let request = URLRequest(url: url)
        //обработка ответа
        //URLSession - An object that coordinates a group of related, network(сеть) data transfer tasks.
        // shared - `class var shared: URLSession { get }` - The shared singleton session (одиночный сеанс) object.
        // dataTask - Creates a task that retrieves(извлекает) the contents of a URL based on the specified URL request object, and calls a handler upon completion.
        //func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(Result.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
             //пытаемся превратить  response в объект класса HTTPURLResponse
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                       //statusCode - The response’s HTTP status code.
                handler(.failure(NetworkError.codeError))
                return
            }
            
            //Обрабатываем успешный ответ (Обычно ответ от сервера — это набор единиц информации в какой-либо кодировке)
             // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
        //Resumes(продолжать) the task, if it is suspended(временно прекращать).
    }
}
