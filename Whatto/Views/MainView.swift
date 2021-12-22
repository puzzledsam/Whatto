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
    
    @State var disabledRandomizer = true
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
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    mainVM.filterByService("Netflix") { result in
                                        print(result)
                                    }
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .padding()
            } else {
                Text("To begin, tap the button below")
            }
            
            Button("Pick a random movie") {
                withAnimation {
                    let t = randMovie
                    while (randMovie == t) {
                        randMovie = mainVM.filteredList.randomElement()?.movie
                    }
                }
                print(randMovie ?? "No Movie")
            }
            .padding()
            .foregroundColor(.white)
            .background(disabledRandomizer ? Color.gray : Color.blue)
            .cornerRadius(10)
            .disabled(disabledRandomizer)
            
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
            mainVM.getWatchlist(accessToken: authentication.retrieveAccessToken()!) { fetchResult in
                print("Get Watchlist result: \(fetchResult)")
                switch (fetchResult) {
                case .success:
                    print("Watchlist fetch succeeded, will filter for Netflix only")
                    mainVM.filterByService("Netflix") { filterResult in
                        print("Filter watchlist result: \(filterResult)")
                        switch (filterResult) {
                        case .success:
                            disabledRandomizer = false
                        case .failure:
                            break
                        }
                    }
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
