//
//  APIError.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}
