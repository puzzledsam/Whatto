//
//  Watchlist.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation

// MARK: - SimklWatchlist
struct SimklWatchlist: Codable {
    let movies: [SimklMovies]?
}

// MARK: - SimklMovies
struct SimklMovies: Codable {
    let movie: SimklMovie
}

// MARK: - SimklMovie
struct SimklMovie: Codable, Equatable {
    let title: String
    let poster: String?
    let year: Int?
    let ids: SimklMovieIDs?
    
    static func ==(a: SimklMovie, b: SimklMovie) -> Bool {
        return a.ids?.simkl == b.ids?.simkl
    }
}

// MARK: - SimklMovieIDs
struct SimklMovieIDs: Codable {
    let simkl: Int?
    let tmdb: String?
}
