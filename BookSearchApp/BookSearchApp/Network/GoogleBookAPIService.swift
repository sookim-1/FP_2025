//
//  GoogleBookAPIService.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

enum GoogleBookAPIService {

    case search(query: String)

}

extension GoogleBookAPIService: APIService {

    var baseURLString: String {
        return "https://www.googleapis.com"
    }

    var pathString: String {
        return "/books/v1/volumes"
    }

    var queryParametersDictionary: [String: String] {
        switch self {
        case .search(let query):
            return [
                "q": query,
            ]
        }
    }

}
