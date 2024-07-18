//
//  MoviesModel.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let posterPath: String

    var imageUrl: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
