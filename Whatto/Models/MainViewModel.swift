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
    
    var serviceFilters: [WatchProvider] = []
    
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
    
    func filterByService(_ serviceName: String?, completion: @escaping (Result<[Movies], TmdbAPI.APIError>) -> Void) {
        if let serviceName = serviceName {
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
                completion(.success(temp))
            }
        } else {
            completion(.success(watchlist?.movies ?? []))
        }
    }
    
    func addServiceFilter(_ watchProvider: WatchProvider) {
        serviceFilters.append(watchProvider)
    }
    
    func removeServiceFilter(_ watchProvider: WatchProvider) {
        if let index = serviceFilters.firstIndex(of: watchProvider) {
            serviceFilters.remove(at: index)
        }
    }
    
    func clearServiceFilters() {
        serviceFilters = []
    }
    
    func refreshFilteredList() {
        filteredList = []
        
        if serviceFilters.isEmpty {filteredList = watchlist?.movies ?? []}
        
        for filter in serviceFilters {
            filterByService(filter.rawValue) { filterResult in
                switch (filterResult) {
                case .success(let movieList):
                    for i in movieList {
                        if !self.filteredList.contains(i) {
                            self.filteredList.append(i)
                        }
                    }
                case .failure:
                    print("Refreshing filtered list failed!")
                    return
                }
            }
        }
        
        print("Filter watchlist result: \(filteredList)")
    }
    
}
