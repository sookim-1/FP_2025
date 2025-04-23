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
        let books: AnyPublisher<[Book], Never>
    }

    func transform(input: Input) -> Output {
        let books = input.textChanged
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query in
                GoogleBookAPIService
                    .search(query: query)
                    .request(GoogleBooksResponseDTO.self)
                    .map(\.items)
                    .map { $0.map { Book(from: $0.volumeInfo) } }
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()

        return Output(books: books)
    }
    
}
