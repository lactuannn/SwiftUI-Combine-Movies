//
//  ContentView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()

    var filteredMovies: [Movie] {
        if homeViewModel.searchText.isEmpty {
            return homeViewModel.movies
        } else {
            return homeViewModel.movies.filter { $0.title.lowercased().contains(homeViewModel.searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $homeViewModel.searchText)
                    .padding(.horizontal)

                List(homeViewModel.movies) { movie in
    //                NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
    //                }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Now Playing")
            }
        }
        .tabItem {
            Label("Movies", systemImage: "film")
        }
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
}


#Preview {
    HomeView()
}
