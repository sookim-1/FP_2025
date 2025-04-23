//
//  ViewController.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private lazy var bookSearchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.placeholder = "검색어를 입력해주세요."
        textField.addTarget(self, action: #selector(bookSearchTextDidChange), for: .editingChanged)
        return textField
    }()

    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private var books: [Book] = []
    private let viewModel = ViewModel()
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bind()
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(bookSearchField)
        view.addSubview(bookTableView)

        NSLayoutConstraint.activate([
            bookSearchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookSearchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookSearchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bookSearchField.heightAnchor.constraint(equalToConstant: 55),

            bookTableView.topAnchor.constraint(equalTo: bookSearchField.bottomAnchor, constant: 20),
            bookTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bind() {
        let input = ViewModel.Input(textChanged: textChangedSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.books
            .map(\.items)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                self?.books = books.map { Book(from: $0.volumeInfo) }
                self?.bookTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc private func bookSearchTextDidChange() {
        guard let text = bookSearchField.text,
              text.count > 1 else { return }

        textChangedSubject.send(text)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = books[indexPath.row].title
        cell.contentConfiguration = content

        return cell
    }

}

