//
//  ViewController.swift
//  BookSearchApp
//
//  Created by sookim on 4/23/25.
//

import UIKit

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

    private var books: [String] = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
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

    @objc private func bookSearchTextDidChange() {
        print("검색어 : \(bookSearchField.text)")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = books[indexPath.row]
        cell.contentConfiguration = content

        return cell
    }

}

