//
//  TmdbAPI.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-22.
//

import Foundation

class TmdbAPI {
    
    static let shared = TmdbAPI()
    enum APIError: Error {
        case error
    }
    
    func getMovieWatchProviders(movieId: Int, completion: @escaping (Result<TmdbMovieWatchProviders,APIError>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/watch/providers?api_key=\(ApiKeys.getTMDBApiKey(legacy: true))")!
        
        let headers = ["content-type": "application/json"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Received response from the TMDB API")
                let decodedResponse = try? JSONDecoder().decode(TmdbMovieWatchProviders.self, from: data)
                if let movieDetails = decodedResponse{
                    print("Decoded watch provider details JSON for movie with id \(movieId)")
                    completion(.success(movieDetails))
                } else {
                    print("Watch provider details could not be decoded")
                    completion(.failure(APIError.error))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(.failure(APIError.error))
            } else {
                print("An unexpected error occured")
                completion(.failure(APIError.error))
            }
        }
        
        task.resume()
    }
    
}
