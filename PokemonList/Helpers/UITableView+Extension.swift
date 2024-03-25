//
//  UITableView+Extension.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit

extension UITableView {

    func registerCell(withType type: UITableViewCell.Type) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: cellId)
    }

    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }

}

extension UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

}
