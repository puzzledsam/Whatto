//
//  SimklAPI.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-15.
//

import Foundation

class SimklAPI {
    
    static var loginURL = "https://simkl.com/oauth/authorize?response_type=code&client_id=\(ApiKeys.getSimklClientId())&redirect_uri=whatto%3A%2F%2F"
    
    static let shared = SimklAPI()
    enum APIError: Error {
        case error, invalidURL
    }
    
    func authenticate(authCode: String) async throws -> String {
        guard let url = URL(string: "https://api.simkl.com/oauth/token") else {
            throw APIError.invalidURL
        }
        
        let body = ["code": authCode,
                    "client_id": ApiKeys.getSimklClientId(),
                    "client_secret": ApiKeys.getSimklClientSecret(),
                    "redirect_uri": "whatto%3A%2F%2F",
                    "grant_type": "authorization_code"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        await Task.sleep(UInt64(5 * Double(NSEC_PER_SEC)))
        
        let decodedResponse = try JSONDecoder().decode([String: String].self, from: data)
        guard let accessToken = decodedResponse["access_token"] else {
            throw APIError.error
        }
        
        return accessToken
    }
    
    func getWatchlist(accessToken: String, type: String = "movies", status: String = "plantowatch") async throws -> SimklWatchlist {
        guard let url = URL(string: "https://api.simkl.com/sync/all-items/\(type)/\(status)") else {
            throw APIError.invalidURL
        }
        
        let headers = ["content-type": "application/json",
                       "Authorization": "Bearer \(accessToken)",
                       "simkl-api-key": ApiKeys.getSimklClientId()]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(SimklWatchlist.self, from: data)
        return decodedResponse
    }
    
}
