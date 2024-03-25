//
//  PokemonItemCell.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit
import Combine

final class PokemonItemCell: UITableViewCell {

    var viewModel: PokemonItemCellViewModel? {
        didSet {
            setupViewModel()
        }
    }

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupConstraints()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }


    private func setupView() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(nameLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
    }

    private func setupViewModel() {
        nameLabel.text = viewModel?.name
    }
}
