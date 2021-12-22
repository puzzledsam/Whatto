//
//  MainViewModel.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation
class MainViewModel: ObservableObject {
    
    @Published var watchlist: Watchlist? = nil
    @Published var filteredList: [Movies] = []
    
    func getWatchlist(accessToken: String, completion: @escaping (Result<Bool,SimklAPI.APIError>) -> Void) {
        SimklAPI.shared.getWatchlist(accessToken: accessToken) { [unowned self](result: Result<Watchlist, SimklAPI.APIError>) in
            switch result {
            case .success(let decodedList):
                DispatchQueue.main.sync {
                    watchlist = decodedList
                    filteredList = decodedList.movies ?? []
                }
                completion(.success(true))
            case .failure:
                completion(.failure(SimklAPI.APIError.error))
            }
        }
    }
    
    func filterByService(_ serviceName: String, completion: @escaping (Result<[Movies], TmdbAPI.APIError>) -> Void) {
        var temp: [Movies] = []
        let dspGroup = DispatchGroup()
        
        for movie in watchlist?.movies ?? [] {
            dspGroup.enter()
            TmdbAPI.shared.getMovieWatchProviders(movieId: Int(movie.movie.ids?.tmdb ?? "0") ?? 0) { (result: Result<TmdbMovieWatchProviders, TmdbAPI.APIError>) in
                switch result {
                case .success(let providers):
                    for provider in providers.results?.ca?.flatrate ?? [] {
                        if provider.isProvider(serviceName){
                            temp.append(movie)
                        }
                    }
                case .failure:
                    completion(.failure(TmdbAPI.APIError.error))
                    break
                }
                
                dspGroup.leave()
            }
        }
        
        dspGroup.notify(queue: .main) {
            self.filteredList = temp
            completion(.success(temp))
        }
        
    }
    
}
