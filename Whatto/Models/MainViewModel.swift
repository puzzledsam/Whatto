//
//  MainViewModel.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-17.
//

import Foundation
class MainViewModel: ObservableObject {
    
    @Published var watchlist: Watchlist? = nil
    
    func getWatchlist(accessToken: String, completion: @escaping (Result<Bool,SimklAPI.APIError>) -> Void) {
        SimklAPI.shared.getWatchlist(accessToken: accessToken) { [unowned self](result: Result<Watchlist, SimklAPI.APIError>) in
            switch result {
            case .success(let decodedList):
                DispatchQueue.main.sync {
                    watchlist = decodedList
                }
                completion(.success(true))
            case .failure:
                completion(.failure(SimklAPI.APIError.error))
            }
        }
    }
    
}
