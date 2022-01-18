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
    
    @State private var disabledRandomizer = true
    @State var randMovie: Movie? = nil
    @State private var netflixFilterToggle = false
    @State private var disneyFilterToggle = false
    
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
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.primary, lineWidth: 3))
                        } placeholder: {
                            ProgressView()
                                .frame(maxHeight: .infinity)
                        }
                    }
                }
                .padding()
            } else {
                Text("To begin, tap the button below")
                    .frame(maxHeight: .infinity)
            }
            
            Button("Pick a random movie") {
                let t = randMovie
                while (randMovie == t) {
                    randMovie = mainVM.filteredList.randomElement()?.movie
                }
                print(randMovie ?? "No Movie")
            }
            .padding()
            .foregroundColor(.white)
            .background(disabledRandomizer ? Color.gray : Color.blue)
            .cornerRadius(10)
            .disabled(disabledRandomizer)
            
            Toggle("Netflix", isOn: $netflixFilterToggle)
                .onChange(of: netflixFilterToggle) { value in
                    if value {
                        mainVM.addServiceFilter(WatchProvider.Netflix)
                    } else {
                        mainVM.removeServiceFilter(WatchProvider.Netflix)
                    }
                    
                    mainVM.refreshFilteredList()
                }
            
            Toggle("Disney", isOn: $disneyFilterToggle)
                .onChange(of: disneyFilterToggle) { value in
                    if value {
                        mainVM.addServiceFilter(WatchProvider.DisneyPlus)
                    } else {
                        mainVM.removeServiceFilter(WatchProvider.DisneyPlus)
                    }
                    
                    mainVM.refreshFilteredList()
                }
            
            Divider()
            
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
        .padding()
        .onAppear {
            mainVM.getWatchlist(accessToken: authentication.retrieveAccessToken()!) { fetchResult in
                print("Get Watchlist result: \(fetchResult)")
                switch (fetchResult) {
                case .success:
                    print("Watchlist fetch succeeded, will filter")
                    mainVM.refreshFilteredList()
                    disabledRandomizer = false
                case.failure:
                    print("Watchlist fetch failed, won't filter")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
