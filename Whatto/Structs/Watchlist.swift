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

struct Movies: Codable {
    let movie: Movie
}

struct Movie: Codable {
    let title: String
    let poster: String?
    let year: Int?
}
