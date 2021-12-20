//
//  MainView.swift
//  Whatto
//
//  Created by Samuel Dion on 2021-12-16.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authentication: Authentication
    @StateObject private var mainVM = MainViewModel()
    
    @State var randMovie: Movie? = nil
    
    var body: some View {
        VStack {
            
            if let selectedMovie = randMovie {
                VStack {
                    Text("\(selectedMovie.title) (\(String(selectedMovie.year ?? 0)))")
                        .font(.title)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let posterId = selectedMovie.poster {
                        AsyncImage(url: URL(string: "https://simkl.in/posters/\(posterId)_m.jpg")) { image in
                            image
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
            } else {
                Text("Click the button below to pick a random movie")
            }
            
            Button("Pick a random movie") {
                withAnimation {
                    randMovie = mainVM.watchlist?.movies?.randomElement()?.movie
                }
                print(randMovie ?? "No Movie")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 30.0)
            
            Button("Log Out") {
                if authentication.storeAccessToken(nil) {
                    print("Logged out successfully, token deleted from Keychain")
                    authentication.validateAuthentication(false)
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .onAppear {
            mainVM.getWatchlist(accessToken: authentication.retrieveAccessToken()!) { result in
                print("Get Watchlist result: \(result)")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
