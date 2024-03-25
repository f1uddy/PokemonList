//
//  ViewControllerFactoryInterface.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit

protocol ViewControllerFactoryInterface {
    func makeRootViewController() -> UIViewController
    func makeListViewController() -> UIViewController
    func makeDetailsViewController(for item: PokemonItem) -> UIViewController
}
