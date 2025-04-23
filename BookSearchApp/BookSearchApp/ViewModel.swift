//
//  ViewModel.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation
import Combine

final class ViewModel: ViewModelType {

    struct Input {
        let textChanged: AnyPublisher<String, Never>
    }

    struct Output {
        let books: AnyPublisher<GoogleBooksResponseDTO, Never>
    }

    func transform(input: Input) -> Output {
        let books = input.textChanged
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query in
                GoogleBookAPIService
                    .search(query: query)
                    .request(GoogleBooksResponseDTO.self)
                    .catch { _ in Just(GoogleBooksResponseDTO(items: [])) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()

        return Output(books: books)
    }
}
