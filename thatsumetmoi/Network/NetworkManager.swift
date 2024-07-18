//
//  NetworkManager.swift
//  thatsumetmoi
//
//  Created by TuanDL2 on 18/7/24.
//

import Foundation
import Combine

enum Constants {
    static let API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNGY3OGFjY2RiZTQwNWNhOGNhYjA0OTY4ZDRlNjMwNiIsIm5iZiI6MTcyMTI5MzEwMi43NDA0MSwic3ViIjoiNTliOThjOTljM2EzNjgxMzUwMDFiYTY5Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.q2dGZbvV1TBnV7ZGEdFXxY-nrSdEYkrUZX7c8VMoZCQ"
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEnvironment {
    case development
    case staging
    case production

    var baseURL: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3"
        case .staging:
            return "staging.example.com"
        case .production:
            return "production.example.com"
        }
    }
}

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]?, parameters: Encodable?) -> AnyPublisher<T, APIError>
}

class NetworkManager: NetworkService {
    private let baseURL: String

    init(environment: APIEnvironment = NetworkManager.defaultEnvironment()) {
        self.baseURL = environment.baseURL
    }

    static func defaultEnvironment() -> APIEnvironment {
#if DEBUG
        return .development
#elseif STAGING
        return .staging
#else
        return .production
#endif
    }

    private func defaultHeaders() -> [String: String] {
        let headers: [String: String] = [
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]

        return headers
    }

    func request<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]? = nil, parameters: Encodable? = nil) -> AnyPublisher<T, APIError> {
         guard let url = URL(string: baseURL + endpoint.path) else {
             return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
         }
         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = endpoint.httpMethod.rawValue
         let allHeaders = defaultHeaders().merging(headers ?? [:], uniquingKeysWith: { (_, new) in new })
         for (key, value) in allHeaders {
             urlRequest.setValue(value, forHTTPHeaderField: key)
         }
         if let parameters = parameters {
             urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
             do {
                 let jsonData = try JSONEncoder().encode(parameters)
                 urlRequest.httpBody = jsonData
             } catch {
                 return Fail(error: APIError.requestFailed("Encoding parameters failed.")).eraseToAnyPublisher()
             }
         }
         return URLSession.shared.dataTaskPublisher(for: urlRequest)
             .tryMap { (data, response) -> Data in
                 // Pretty-print the JSON response
                 if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
                    let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                     print("Response JSON: \(prettyPrintedString)")
                 }

                 if let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode) {
                     return data
                 } else {
                     let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                     throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                 }
             }
             .decode(type: T.self, decoder: JSONDecoder())
//             .tryMap { (responseWrapper) -> T in
//                 guard let status = responseWrapper.status else {
//                     throw APIError.requestFailed("Missing status.")
//                 }
//                 switch status {
//                 case 200:
//                     guard let data = responseWrapper.data else {
//                         throw APIError.requestFailed("Missing data.")
//                     }
//                     return data
//                 default:
//                     let message = responseWrapper.message ?? "An error occurred."
//                     throw APIError.requestFailed(message)
//                 }
//             }
             .mapError { error -> APIError in
                 if error is DecodingError {
                     return APIError.decodingFailed
                 } else if let apiError = error as? APIError {
                     return apiError
                 } else {
                     // Print the error description
                     print("Error: \(error.localizedDescription)")
                     return APIError.requestFailed("An unknown error occurred.")
                 }
             }
             .eraseToAnyPublisher()
     }
}

/*
This is not for the TMDB API
They doesn't have status or message
Will be used in another project
 */

//struct ResponseWrapper<T: Decodable>: Decodable {
//    let status: Int?
//    let message: String?
//    let data: T?
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        status = try container.decodeIfPresent(Int.self, forKey: .status)
//        message = try container.decodeIfPresent(String.self, forKey: .message)
//        data = try container.decodeIfPresent(T.self, forKey: .data)
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case status
//        case message
//        case data
//    }
//}
