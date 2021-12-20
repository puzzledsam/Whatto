//
//  WhattoApp.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-15.
//

import SwiftUI

@main
struct WhattoApp: App {
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                MainView()
                    .environmentObject(authentication)
            } else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
    }
}
