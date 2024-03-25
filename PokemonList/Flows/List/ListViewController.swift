//
//  ListViewController.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit
import Combine

final class ListViewController: UIViewController {

    private typealias DataSource = UITableViewDiffableDataSource<ListViewModel.Section, PokemonItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ListViewModel.Section, PokemonItem>

    // MARK: - Properties

    var viewModel: ListViewModel?

    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DataSource?

    // MARK: - UI properties

    private lazy var tableView = UITableView()
    private weak var refreshControl: UIRefreshControl?
    private lazy var activityIndicationView = UIActivityIndicatorView(style: .large)

    // MARK: - UIViewController

    override func loadView() {
        view = UIView()
        setupView()
        setupConstraints()
        setupRefreshControl()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
        viewModel?.input.loadData.send(())
    }

}

// MARK: - Private methods

private extension ListViewController {

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView,
                                cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(withType: PokemonItemCell.self, for: indexPath) as? PokemonItemCell else {
                return UITableViewCell()
            }
            cell.viewModel = PokemonItemCellViewModel(pokemon: item)
            return cell
        })
    }

    func updateSections() {
        guard let dataSource = dataSource, let viewModel = viewModel else {
            return
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.pokemons])
        snapshot.appendItems(viewModel.pokemons)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reload", style: .default) { [weak self] _ in
            self?.viewModel?.input.refresh.send(())
        }
        alertController.addAction(alertAction)
        alertController.addAction(.init(title: "Close", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }

    func startLoading() {
        tableView.isUserInteractionEnabled = false

        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }

    func finishLoading() {
        tableView.isUserInteractionEnabled = true

        activityIndicationView.stopAnimating()
    }

}

// MARK: - Appearance

private extension ListViewController {

    func setupView() {
        navigationItem.title = "Pokemon List"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(withType: PokemonItemCell.self)
        view.addSubview(tableView)
        view.addSubview(activityIndicationView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
    }

}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel?.input.itemSelected.send(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions

private extension ListViewController {

    @objc func refreshContent(refreshControl: UIRefreshControl) {
        viewModel?.input.refresh.send()
        refreshControl.endRefreshing()
    }
}

// MARK: - Binding

private extension ListViewController {
    func bindViewModel() {
        viewModel?.output.results
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in

            }, receiveValue: { [weak self] _ in
                self?.updateSections()
            })
            .store(in: &cancellables)

        let receiveValue: (ListViewModel.State) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.startLoading()
            case .finished:
                self?.finishLoading()
            case .error(let error):
                self?.finishLoading()
                self?.showError(error)
            }
        }

        viewModel?.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: receiveValue)
            .store(in: &cancellables)
    }
}
