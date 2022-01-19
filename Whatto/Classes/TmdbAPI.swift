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
        case error, invalidURL
    }
    
    func getMovieWatchProviders(movieId: Int) async throws -> TmdbMovieWatchProviders {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/watch/providers?api_key=\(ApiKeys.getTMDBApiKey(legacy: true))") else {
            throw APIError.invalidURL
        }
        
        let headers = ["content-type": "application/json"]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(TmdbMovieWatchProviders.self, from: data)
        return decodedResponse
    }
    
}
