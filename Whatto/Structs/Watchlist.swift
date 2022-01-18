//
//  Watchlist.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation

struct Watchlist: Codable {
    let movies: [Movies]?
}

struct Movies: Codable, Equatable {
    let movie: Movie
}

struct Movie: Codable, Equatable {
    let title: String
    let poster: String?
    let year: Int?
    let ids: MovieIDs?
    
    static func ==(a: Movie, b: Movie) -> Bool {
        return a.title == b.title && a.year == b.year
    }
}

struct MovieIDs: Codable {
    let simkl: Int?
    let tmdb: String?
}
