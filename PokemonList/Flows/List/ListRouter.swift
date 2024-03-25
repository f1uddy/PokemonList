//
//  ListRouter.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit

protocol ListRouterInterface {
    func showDetails(for item: PokemonItem)
}

final class ListRouter {

    private let factory: ViewControllerFactoryInterface
    private weak var context: UIViewController?

    init(factory: ViewControllerFactoryInterface,
         context: UIViewController?) {
        self.factory = factory
        self.context = context
    }

}

extension ListRouter: ListRouterInterface {
    func showDetails(for item: PokemonItem) {
        let viewController = factory.makeDetailsViewController(for: item)
        context?.navigationController?.pushViewController(viewController, animated: true)
    }
}
