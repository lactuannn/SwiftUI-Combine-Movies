//
//  ContentView.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List(homeViewModel.movies) { movie in
//                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRowView(movie: movie)
//                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Now Playing")
        }
        .tabItem {
            Label("Movies", systemImage: "film")
        }
    }
}

#Preview {
    HomeView()
}
