//
//  AppDelegate.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let factory = ViewControllerFactory()

    var window: UIWindow?

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = factory.makeRootViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

