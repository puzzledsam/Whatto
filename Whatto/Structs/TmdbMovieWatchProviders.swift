//
//  TmdbMovieWatchProviders.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-22.
//

import Foundation

// MARK: - Watch Providers
enum WatchProviders: String {
    case Netflix = "Netflix"
    case DisneyPlus = "Disney Plus"
}

struct WatchProvider {
    let provider: WatchProviders
    let logoPath: String?
    
    func getURL() -> String {
        switch self.provider {
        case .Netflix:
            return "nflx://"
        case .DisneyPlus:
            return "disneyplus://"
        }
    }
}

// MARK: - TmdbMovieWatchProviders
struct TmdbMovieWatchProviders: Codable {
    let id: Int?
    let results: TmdbProviderResults?
}

// MARK: - Results
struct TmdbProviderResults: Codable {
    let us, ca: TmdbWatchCountryDetails?

    enum CodingKeys: String, CodingKey {
        case us = "US"
        case ca = "CA"
    }
}

// MARK: - WatchCountryDetails
struct TmdbWatchCountryDetails: Codable {
    let link: String?
    let flatrate, rent, buy: [TmdbWatchLinks]?
}

// MARK: - WatchLinks
struct TmdbWatchLinks: Codable {
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
