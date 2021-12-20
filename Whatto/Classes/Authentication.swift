//
//  Authentication.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-16.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper

class Authentication: ObservableObject {
    
    private let ACCESS_TOKEN_KEY = "SimklAccessToken"
    
    @Published var isValidated = false
    
    func validateAuthentication(_ validAuthentication: Bool) {
        withAnimation {
            isValidated = validAuthentication
        }
    }
    
    func retrieveAccessToken() -> String? {
        if let token = KeychainWrapper.standard.string(forKey: ACCESS_TOKEN_KEY) {
            print("Access token exists in Keychain")
            return token
        } else {
            print("No access token found, login is required")
            return nil
        }
    }
    
    func storeAccessToken(_ token: String?) -> Bool {
        if let token = token {
            return KeychainWrapper.standard.set(token, forKey: ACCESS_TOKEN_KEY)
        } else {
            return KeychainWrapper.standard.removeObject(forKey: ACCESS_TOKEN_KEY)
        }
    }
}
