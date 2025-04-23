//
//  Dictionary+Ext.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

extension Dictionary {

    public var urlQueryItems: [URLQueryItem]? {
        let queryItems = self.map { (key, value) in
            URLQueryItem(name: String(describing: key),
                         value: String(describing: value))
        }

        return queryItems
    }

}
