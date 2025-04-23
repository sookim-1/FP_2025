//
//  MyTableViewAdapter.swift
//  BookSearchApp
//
//  Created by sookim on 4/24/25.
//

import UIKit
import Combine

final class MyTableViewAdapter<Item, CustomCell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {

    typealias ConfigureCell = (CustomCell, Item) -> Void
    
    private(set) var items: [Item] = []
    private let configureCell: ConfigureCell
    private(set) var didSelect: ((Item) -> Void)?
    private var cancellable: AnyCancellable?

    init(configureCell: @escaping ConfigureCell) {
        self.configureCell = configureCell
    }

    func update(items: [Item]) {
        self.items = items
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else { return UITableViewCell() }
        
        configureCell(cell, items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(items[indexPath.row])
    }

}
