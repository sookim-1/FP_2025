//
//  ViewModelType.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import Foundation

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output

}
