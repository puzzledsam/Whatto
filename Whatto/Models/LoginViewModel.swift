//
//  LoginViewModel.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-16.
//

import Foundation
import UIKit

class LoginViewModel: ObservableObject {
    
    @Published var showProgressView = false
    
    func signIn(authCode: String, completion: @escaping (Result<String,SimklAPI.APIError>) -> Void) {
        showProgressView = true
        SimklAPI.shared.authenticate(authCode: authCode) { [unowned self](result: Result<String, SimklAPI.APIError>) in
            DispatchQueue.main.sync {
                showProgressView = false
            }
            switch result {
            case .success(let token):
                completion(.success(token))
            case .failure:
                completion(.failure(SimklAPI.APIError.error))
            }
        }
    }
}
