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
    
    /*func getAuthenticationPin() {
        let url = URL(string: "https://api.simkl.com/oauth/pin?client_id=\(SimklAPI.CLIENT_ID)&redirect=https%3A%2F%2Fpuzzledsam.github.io%2Fwhatto%2F")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(decoding: data, as: UTF8.self))
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            } else {
                print("An unexpected error occured")
            }
        }
        
        task.resume()
    }*/
    
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
        
        let decodedResponse = try JSONDecoder().decode([String: String].self, from: data)
        guard let accessToken = decodedResponse["access_token"] else {
            throw APIError.error
        }
        
        return accessToken
    }
    
    /*func oldthenticate(authCode: String, completion: @escaping (Result<String,APIError>) -> Void) {
        let url = URL(string: "https://api.simkl.com/oauth/token")!
        
        let body = ["code": authCode,
                    "client_id": ApiKeys.getSimklClientId(), 
                    "client_secret": ApiKeys.getSimklClientSecret(),
                    "redirect_uri": "whatto%3A%2F%2F",
                    "grant_type": "authorization_code"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Received response from the authentication server")
                let decodedResponse = try? JSONDecoder().decode([String: String].self, from: data)
                if let accessToken = decodedResponse?["access_token"]{
                    print("Decoded access token")
                    completion(.success(accessToken))
                } else {
                    print("No access token found in response")
                    completion(.failure(APIError.error))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(.failure(APIError.error))
            } else {
                print("An unexpected error occured")
                completion(.failure(APIError.error))
            }
        }
        
        task.resume()
    }*/
    
    func getWatchlist(accessToken: String, type: String = "movies", status: String = "plantowatch", completion: @escaping (Result<SimklWatchlist,APIError>) -> Void) {
        let url = URL(string: "https://api.simkl.com/sync/all-items/\(type)/\(status)")!
        
        let headers = ["content-type": "application/json",
                       "Authorization": "Bearer \(accessToken)",
                       "simkl-api-key": ApiKeys.getSimklClientId()]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Received response from the API")
                let decodedResponse = try? JSONDecoder().decode(SimklWatchlist.self, from: data)
                if let watchlist = decodedResponse{
                    print("Decoded watchlist JSON")
                    completion(.success(watchlist))
                } else {
                    print("Watchlist could not be decoded")
                    completion(.failure(APIError.error))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                completion(.failure(APIError.error))
            } else {
                print("An unexpected error occured")
                completion(.failure(APIError.error))
            }
        }
        
        task.resume()
    }
    
}
