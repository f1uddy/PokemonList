//
//  ViewControllerFactory.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import UIKit

final class ViewControllerFactory {

}

extension ViewControllerFactory: ViewControllerFactoryInterface {

    func makeRootViewController() -> UIViewController {
        return makeListViewController()
    }
    
    func makeListViewController() -> UIViewController {
        let view = UIViewController.instantiate(ofType: ListViewController.self)
        let router = ListRouter(factory: self, context: view)
        let viewModel = ListViewModel(router: router, service: ListService())

        view.viewModel = viewModel
        return UINavigationController(rootViewController: view)
    }

    func makeDetailsViewController(for item: PokemonItem) -> UIViewController {
        let view = UIViewController.instantiate(ofType: DetailsViewController.self)
        let viewModel = DetailsViewModel(service: DetailsService(), listItem: item)
        view.viewModel = viewModel
        return view
    }

}
