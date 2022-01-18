//
//  Watchlist.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation

struct SimklWatchlist: Codable {
    let movies: [SimklMovies]?
}

struct SimklMovies: Codable {
    let movie: SimklMovie
}

struct SimklMovie: Codable, Equatable {
    let title: String
    let poster: String?
    let year: Int?
    let ids: SimklMovieIDs?
    
    static func ==(a: SimklMovie, b: SimklMovie) -> Bool {
        return a.title == b.title && a.year == b.year
    }
}

struct SimklMovieIDs: Codable {
    let simkl: Int?
    let tmdb: String?
}
