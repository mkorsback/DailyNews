//
//  CachedImageView.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-10.
//

import UIKit

let imageCache = NSCache<NSURL, UIImage>()

class CachedImageView: UIImageView {

  var imageUrl: URL?
  let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()

  func load(from url: URL) {
    imageUrl = url
    image = nil

    if let image = imageCache.object(forKey: url as NSURL) {
      self.image = image
      return
    }

    addSubview(spinner)
    spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    spinner.startAnimating()

    URLSession.shared.dataTask(with: url) { data, _, error in
      if error != nil {
        return
      }

      if let data = data, let image = UIImage(data: data) {
        if self.imageUrl == url {
          DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
            self.image = image
            imageCache.setObject(image, forKey: url as NSURL)
          }
        }
      }
    }.resume()
  }

}
