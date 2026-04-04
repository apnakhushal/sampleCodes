//
//  APIService.swift
//  CombineBasicsPartOne
//
//  Created by Khushal on 18/03/2026.
//

import Combine
import Foundation

class APIService {
    func fetchMovie(movieID: String,
                    completion: @escaping (Result<Movie, Error>) -> Void) {

        let url = URL(string: "https://api.imdbapi.dev/titles/\(movieID)")!

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }

            do {
                let user = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    // immediate execution as soon as its initialized
    func fetchMoviePublisher(movieID: String) -> Future<Movie, Error> {
        return Future { promise in
            print("kjkj start executing ONLY Future fetchMovie...")
            self.fetchMovie(movieID: movieID) { result in
                promise(result)
            }
        }
    }
    
    func fetchMovieDeferredPublisher(movieID: String) -> AnyPublisher<Movie, Error> {
        Deferred {
            Future { promise in
                print("kjkj start executing Future with Deferred fetchMovie...")
                self.fetchMovie(movieID: movieID) { result in
                    promise(result)
                }
            }
        }.eraseToAnyPublisher()
    }
}
