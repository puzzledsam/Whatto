//
//  TmdbMovieWatchProviders.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-22.
//

import Foundation

enum WatchProvider: String {
    case Netflix = "Netflix"
    case DisneyPlus = "Disney Plus"
}

struct TmdbMovieWatchProviders: Codable {
    let id: Int?
    let results: Results?
}

// MARK: - Results
struct Results: Codable {
    let us, ca: WatchCountryDetails?

    enum CodingKeys: String, CodingKey {
        case us = "US"
        case ca = "CA"
    }
}

// MARK: - WatchCountryDetails
struct WatchCountryDetails: Codable {
    let link: String?
    let flatrate, rent, buy: [WatchLinks]?
}

// MARK: - WatchLinks
struct WatchLinks: Codable {
    let displayPriority: Int?
    let logoPath: String?
    let providerID: Int?
    let providerName: String?

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }
    
    func isProvider(_ serviceName: String) -> Bool {
        return serviceName == self.providerName
    }
}
