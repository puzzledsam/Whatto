//
//  MainViewModel.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation
class MainViewModel: ObservableObject {
    
    @Published var watchlist = Watchlist()
    
    func getWatchlist(accessToken: String, completion: @escaping (Result<Bool,SimklAPI.APIError>) -> Void) {
        SimklAPI.shared.getWatchlist(accessToken: accessToken) { [unowned self](result: Result<SimklWatchlist, SimklAPI.APIError>) in
            switch result {
            case .success(let decodedList):
                
                decodedList.movies?.forEach({ SimklMovie in
                    watchlist.addMovie(SimklMovie.movie, providers: []) // TODO: Finish re-implementing providers
                })
                
                completion(.success(true))
            case .failure:
                completion(.failure(SimklAPI.APIError.error))
            }
        }
    }
    
    func getMovieWatchProviders(tmdbId: String, completion: @escaping (Result<[WatchProvider],TmdbAPI.APIError>) -> Void) {
        var providerList: [WatchProvider] = []
        
        TmdbAPI.shared.getMovieWatchProviders(movieId: Int(tmdbId) ?? 0) { (result: Result<TmdbMovieWatchProviders, TmdbAPI.APIError>) in
            switch result {
            case .success(let movieProviders):
                for provider in (movieProviders.results?.ca?.flatrate ?? []) {
                    if let validProvider = WatchProvider(rawValue: provider.providerName ?? "") {
                        providerList.append(validProvider)
                    }
                }
            case .failure:
                completion(.failure(TmdbAPI.APIError.error))
                break
            }
        }
    }
    
}
