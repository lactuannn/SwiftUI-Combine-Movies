//
//  HomeViewModel.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Combine
import Foundation
import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText = ""

    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        setupSearch()
        fetchNowPlayingMovies() // Fetch the original movie list initially
    }

    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                if searchTerm.isEmpty {
                    self?.fetchNowPlayingMovies()
                } else {
                    self?.searchMovies(query: searchTerm)
                }
            }
            .store(in: &cancellables)

        
    }

    private func fetchNowPlayingMovies() {
        let response: AnyPublisher<MovieResponse, APIError> = networkManager.request(.nowPlaying, headers: nil)

        response
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching now playing movies: \(error)")
                }
            }, receiveValue: { [weak self] movieResponse in
                self?.movies = movieResponse.results
            })
            .store(in: &cancellables)
    }

    private func searchMovies(query: String) {
        let response: AnyPublisher<MovieResponse, APIError> = networkManager.request(.searchMovies(query: query), headers: nil)

        response
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error searching movies: \(error)")
                }
            }, receiveValue: { [weak self] movieResponse in
                self?.movies = movieResponse.results
            })
            .store(in: &cancellables)
    }
}
