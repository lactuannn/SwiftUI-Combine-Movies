//
//  Endpoints.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation

enum Endpoint {
    case nowPlaying
    case examplePutOne

    var path: String {
        switch self {
        case .nowPlaying:
            return "/movie/now_playing?language=en-US&page=1"
        case .examplePutOne:
            return ""
        }
    }

    var httpMethod: HttpMethod {
        switch self {
        case .nowPlaying:
            return .get
        default:
            return .post
        }
    }
}
