//
//  GoogleBooksResponseDTO.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

struct GoogleBooksResponseDTO: Codable {

    let items: [BookItemDTO]

}

struct BookItemDTO: Codable {

    let volumeInfo: VolumeInfoDTO

}

struct VolumeInfoDTO: Codable {

    let title: String
    let imageLinks: ImageLinksDTO?

}

struct ImageLinksDTO: Codable {

    let thumbnail: String
    
}
