//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 16.05.2023.
//

import Foundation

struct AllMostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let imageURL: URL
    let titleYear: String
    let rating: String
                // why not Double ?
    
    private enum CodingKeys: String, CodingKey {
                                     //CodingKey - A type that can be used as a key for encoding and decoding.
        case titleYear = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    private enum ParseErrors: Error {
        case imageURL
    }
    init(from decoder: Decoder) throws {
        //protocol Decoder - A type that can decode values from a native format into in-memory representations.
//создать контейнер, содержащий все поля будущей структуры. Оттуда будем доставать значения по ключам
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey - Returns the data stored in this decoder as represented in a container keyed by the given key type.
        titleYear = try container.decode(String.self, forKey: .titleYear)
        //func decode(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String - Decodes a value of the given type for the given key.
        rating = try container.decode(String.self, forKey: .rating)
        var imageURLTmp = try container.decode(String.self, forKey: .imageURL)
       // guard let imageURLTmp = imageURLTmp else { print(ParseErrors.imageURL); return}
        guard let imageURLTmp = URL(string: imageURLTmp) else {
            //print("Unable to define imageURL")
            throw ParseErrors.imageURL
            //throw - statement to throw an error.
        }
        imageURL = imageURLTmp
    }
}
