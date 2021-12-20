//
//  ContentView.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-15.
//

import SwiftUI
import BetterSafariView

struct LoginView: View {
    
    @EnvironmentObject var authentication: Authentication
    @StateObject private var loginViewModel = LoginViewModel()
    
    @State private var startingAuthenticationSession = false
    
    var body: some View {
        VStack {
            Text("Whatto")
                .font(.system(size: 50.0))
                .fontWeight(.heavy)
            
            Text("For those moments when you just can't decide...")
                .font(.caption)
                .padding(.bottom, 30)
            
            VStack(spacing: 20) {
                
                Text("Sign in with:")
                
                Button(action: {
                    startingAuthenticationSession = true
                }) {
                    Image("SimklLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
                .padding()
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.primary, lineWidth: 3))
                .webAuthenticationSession(isPresented: $startingAuthenticationSession) {
                    WebAuthenticationSession(url: URL(string: SimklAPI.loginURL)!, callbackURLScheme: "whatto") { callbackURL, error in
                        if let callbackURL = callbackURL {
                            print("Callback URL received")
                            if let codeValue = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "code" })?.value {
                                print("Decoded auth code from callback URL, requesting exchange for access token")
                                loginViewModel.signIn(authCode: codeValue) { result in
                                    switch result {
                                    case .success(let token):
                                        print("Sign in successful")
                                        if authentication.storeAccessToken(token) {
                                            print("Access token stored in Keychain successfully")
                                            DispatchQueue.main.sync {
                                                authentication.validateAuthentication(true)
                                            }
                                        } else {
                                            print("Access token could not be stored in Keychain")
                                        }
                                    case .failure:
                                        print("Sign in failed")
                                    }
                                }
                            }
                            else {
                                print("Key code not found in callback")
                            }
                        } else if let error = error {
                            print("OAuth Request Failed \(error)")
                        } else {
                            print("An unexpected error occured")
                        }
                    }
                    .prefersEphemeralWebBrowserSession(false)
                }
            }
            .padding(20)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
        }
        .padding()
        .disabled(loginViewModel.showProgressView)
        .overlay {
            if loginViewModel.showProgressView {
                ProgressView()
            }
        }
        .onAppear {
            if authentication.retrieveAccessToken() != nil {
                authentication.validateAuthentication(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
