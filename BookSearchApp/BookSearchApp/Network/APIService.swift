//
//  APIService.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation
import Combine

protocol APIService {

    var baseURLString: String { get }
    var pathString: String { get }
    var queryParametersDictionary: [String: String] { get }

    func makeURLRequest() -> URLRequest?
    func request<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, NetworkError>

}

extension APIService {

    func makeURLRequest() -> URLRequest? {
        let urlString = baseURLString + pathString
        var components = URLComponents(string: urlString)
        components?.queryItems = queryParametersDictionary.urlQueryItems

        guard let url = components?.url else { return nil }

        let request = URLRequest(url: url)

        return request
    }

    func request<T: Decodable>(_ type: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let request = makeURLRequest() else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }

                guard (200..<300).contains(httpResponse.statusCode) else {
                    return Fail(error: .serverError(statusCode: httpResponse.statusCode)).eraseToAnyPublisher()
                }

                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { NetworkError.decodingFailed($0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

}
