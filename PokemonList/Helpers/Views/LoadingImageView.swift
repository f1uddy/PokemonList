//
//  LoadingImageView.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 25.03.2024.
//

import UIKit

final class LoadingImageView: UIImageView {

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL) {

        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        if let imageFromCache = ImageCache.shared.object(forKey: NSString(string: url.absoluteString)) {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            DispatchQueue.main.async {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == url {
                        self.image = imageToCache
                    }

                    ImageCache.shared.setObject(imageToCache, forKey: NSString(string: url.absoluteString))
                }
                self.activityIndicator.stopAnimating()
            }
        }).resume()
    }
}
