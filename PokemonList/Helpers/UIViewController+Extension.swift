//
//  UIViewController+Extension.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit

extension UIViewController {

    @objc class var className: String {
        if let name = NSStringFromClass(self).components(separatedBy: ".").last {
            return name
        }
        return ""
    }

    static func instantiate<ViewController: UIViewController>(ofType: ViewController.Type) -> ViewController {
        return .init(nibName: ofType.className, bundle: Bundle(for: ofType))
    }

}
