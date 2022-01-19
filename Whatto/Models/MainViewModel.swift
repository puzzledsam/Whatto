//
//  MainViewModel.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation
class MainViewModel: ObservableObject {
    
    @Published var watchlist = Watchlist()
    
    func getWatchlist(accessToken: String) async {
        do {
            let SimklWatchlist = try await SimklAPI.shared.getWatchlist(accessToken: accessToken)
            
            for SimklMovie in SimklWatchlist.movies ?? [] {
                let providers = await getMovieWatchProviders(tmdbId: SimklMovie.movie.ids?.tmdb ?? "")
                watchlist.addMovie(SimklMovie.movie, providers: providers) // TODO: Finish re-implementing providers
            }
        } catch {
            print("Watchlist fetch request failed with error: \(error)")
        }
    }
    
    func getMovieWatchProviders(tmdbId: String) async -> [WatchProvider] {
        var providerList: [WatchProvider] = []
        
        do {
            let movieProviders = try await TmdbAPI.shared.getMovieWatchProviders(movieId: Int(tmdbId) ?? 0)
            
            for provider in (movieProviders.results?.ca?.flatrate ?? []) {
                if let validProvider = WatchProvider(rawValue: provider.providerName ?? "") {
                    providerList.append(validProvider)
                }
            }
        } catch {
            print("Provider fetch request failed for movie with ID \(tmdbId) with error: \(error)")
        }
        
        return providerList
    }
    
}
