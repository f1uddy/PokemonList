//
//  DetailsViewController.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit
import Combine

final class DetailsViewController: UIViewController {

    private typealias DataSource = UITableViewDiffableDataSource<DetailsViewModel.Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DetailsViewModel.Section, AnyHashable>

    // MARK: - Properties

    var viewModel: DetailsViewModel?

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
        viewModel?.input.loadData.send(())
    }

}

// MARK: - Private methods

private extension DetailsViewController {

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView,
                                cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueCell(withType: PokemonInfoCell.self, for: indexPath) as? PokemonInfoCell else {
                return UITableViewCell()
            }
            if let model = item as? DetailsModel {
                cell.model = model
            }
            return cell
        })
    }

    func updateSections() {
        guard let dataSource = dataSource, let viewModel = viewModel else {
            return
        }
        var snapshot = Snapshot()
        snapshot.appendSections([.info, .stats, .generation])
        snapshot.appendItems([viewModel.pokemonModel], toSection: .info)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reload", style: .default) { [weak self] _ in
            self?.viewModel?.input.refresh.send(())
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { [weak self] _ in
            // TODO: Add router
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        alertController.addAction(closeAction)
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

private extension DetailsViewController {

    func setupView() {
        navigationItem.title = "Pokemon Details"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(withType: PokemonInfoCell.self)
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

// MARK: - Actions

private extension DetailsViewController {

    @objc func refreshContent(refreshControl: UIRefreshControl) {
        viewModel?.input.refresh.send()
        refreshControl.endRefreshing()
    }
}

// MARK: - Binding

private extension DetailsViewController {
    func bindViewModel() {
        viewModel?.output.results
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in

            }, receiveValue: { [weak self] _ in
                self?.updateSections()
            })
            .store(in: &cancellables)




        let receiveValue: (DetailsViewModel.State) -> Void = { [weak self] state in
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
