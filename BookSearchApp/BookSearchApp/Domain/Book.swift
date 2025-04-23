//
//  Book.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

struct Book {

    let title: String
    let thumbnailURL: URL?

}

extension Book {

    init(from dto: VolumeInfoDTO) {
        self.title = dto.title
        self.thumbnailURL = URL(string: dto.imageLinks?.thumbnail ?? "")
    }

}
