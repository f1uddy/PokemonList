//
//  ImageCache.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 25.03.2024.
//

import Foundation
import UIKit

final class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}
