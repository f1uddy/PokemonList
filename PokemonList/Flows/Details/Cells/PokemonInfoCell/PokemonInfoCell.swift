//
//  PokemonInfoCell.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 22.03.2024.
//

import UIKit
import Combine

final class PokemonInfoCell: UITableViewCell {

    var model: DetailsModel? {
        didSet {
            setupViewModel()
        }
    }

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        return view
    }()

    private var pokemonImageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private var statsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .equalCentering
        view.alignment = .center
        return view
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
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(pokemonImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(statsStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            pokemonImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 90),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 90),
            pokemonImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),

            statsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            statsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            statsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func setupViewModel() {
        guard let pokemon = model?.pokemon else {
            return
        }
        statsStackView.arrangedSubviews.forEach { view in
            statsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        nameLabel.text = pokemon.name.uppercased()

        if let defaultImage = pokemon.sprites?.defaultImage, let imageUrl = URL(string: defaultImage) {
            pokemonImageView.loadImageWithUrl(imageUrl)
        }

        if let stats = pokemon.stats {
            let hp = stats[0].statValue
            let attack = stats[1].statValue
            let defense = stats[2].statValue

            statsStackView.addArrangedSubview(makeStatView(for: "HP", with: hp))
            statsStackView.addArrangedSubview(makeStatView(for: "Attack", with: attack))
            statsStackView.addArrangedSubview(makeStatView(for: "Defense", with: defense))
        }
    }

}

private extension PokemonInfoCell {

    func makeStatView(for title: String, with value: Int) -> UIView {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.text = title

        let statLabel = UILabel()
        statLabel.textAlignment = .center
        statLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        statLabel.text = String(value)

        let vStackView = UIStackView(arrangedSubviews: [titleLabel, statLabel])
        vStackView.axis = .vertical
        vStackView.alignment = .center

        return vStackView
    }

}

