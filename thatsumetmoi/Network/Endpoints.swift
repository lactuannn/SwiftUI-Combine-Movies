//
//  Endpoints.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation

enum Endpoint {
    case nowPlaying
    case searchMovies(query: String)

    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing?language=en-US&page=1"
        case .searchMovies(let query):
            return "/search/movie?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&language=en-US&page=1"
        }
    }

    var httpMethod: HttpMethod {
        switch self {
        case .nowPlaying, .searchMovies:
            return .get
        }
    }
}
