//
//  HomeViewModel.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchMovies()
    }

    func fetchMovies() {
        let response: AnyPublisher<MovieResponse, APIError> = networkManager.request(.nowPlaying, headers: nil)

        response
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching movies: \(error)")
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies.results
            })
            .store(in: &cancellables)
    }
}
