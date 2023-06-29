//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Александр Медведев on 17.05.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<AllMostPopularMovies, Error>) -> Void)
}
struct MoviesLoader: MoviesLoading {
    //1 How does return operate inside of switch
    private let networkClient: NetworkRouting
  
    init(networkClient: NetworkRouting = NetworkClient()) {
          self.networkClient = networkClient
      }
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_fq9wx2n1") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
            //preconditionFailure - Indicates that a precondition was violated(нарушать)
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<AllMostPopularMovies, Error>) -> Void) {
                    //handler - манипулятор
        //get the data on desired Movies from network
         //fetch the data from  the machine, which stores it
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
             case .failure(let error):
                handler(.failure(error))
                return
             case .success(let data):
                //construct the AllMostPopularMovies object
                //return it using handler
                do {
                    //JSONDecoder() - An object that decodes instances of a data type from JSON objects.
                    //decode - Returns a value of the type you specify, decoded from a JSON object.
                    let allMostPopularMovies = try JSONDecoder().decode(AllMostPopularMovies.self, from: data)
                    handler(.success(allMostPopularMovies))
                } catch {
                    print("Failed to parse the downloaded list of movies")
                    handler(.failure(error))
                }
            }
        }
    }
}

