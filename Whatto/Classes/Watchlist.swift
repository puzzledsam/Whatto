//
//  Watchlist.swift
//  Whatto
//
//  Created by Samuel Dion on 2022-01-18.
//

import Foundation

class Watchlist: ObservableObject {
    
    private var all: [MovieDetails] = []
    @Published var filtered: [MovieDetails] = []
    
    var serviceFilters: [WatchProvider: Bool] = [:]
    
    func addMovie(_ movie: SimklMovie, providers: [WatchProvider]) {
        all.append(MovieDetails(movie: movie, providers: providers))
    }
    
    func setProviders(to movie: SimklMovie, _ providers: [WatchProvider]) {
        if let index = all.firstIndex(where: { $0.movie == movie  }) {
            all[index] = MovieDetails(movie: movie, providers: providers)
        }
    }
    
    func filteredByService(_ service: WatchProvider?) -> [MovieDetails] {
        if let service = service {
            var temp: [MovieDetails] = []
            
            for movie in all {
                if movie.providers.contains(service) {
                    temp.append(movie)
                }
            }
            
            return temp
        } else {
            return all
        }
    }
    
    func refreshFilteredList() {
        filtered = []
        if !serviceFilters.values.contains(true) {filtered = all; return}
        
        for filter in serviceFilters {
            if filter.value {
                filteredByService(filter.key).forEach { movieDetails in
                    if !filtered.contains(where: { $0.movie == movieDetails.movie }) {
                        filtered.append(movieDetails)
                    }
                }
            }
        }
    }
}
