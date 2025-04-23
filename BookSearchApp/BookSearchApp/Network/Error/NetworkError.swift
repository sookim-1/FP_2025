//
//  NetworkError.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

enum NetworkError: Error {

    case invalidRequest
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    
}
