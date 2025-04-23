//
//  ViewController.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    typealias BookTableAdapter = MyTableViewAdapter<Book, MyTableViewCell>
    
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
        return tableView
    }()

    private let viewModel = ViewModel()
    private let textChangedSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    private(set) var adapter: BookTableAdapter!

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
        
        
        adapter = BookTableAdapter { cell, item in
            cell.setLabel(item.title)
        }
        
        bookTableView.register(MyTableViewCell.self, forCellReuseIdentifier: String(describing: MyTableViewCell.self))
        bookTableView.delegate = adapter
        bookTableView.dataSource = adapter
    }

    private func bind() {
        let input = ViewModel.Input(textChanged: textChangedSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] books in
                self?.adapter.update(items: books)
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
