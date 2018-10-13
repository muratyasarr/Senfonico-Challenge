//
//  UIImageView+Extension.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

extension UIImageView {
    private static var urlString: String = ""
    static var currentTask: URLSessionDataTask = URLSessionDataTask()
    
    func loadImage(withURL url: URL) {
        if let image = ImageCache.shared.image(forKey: url.absoluteString) {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
                ImageCache.shared.save(image: image, forKey: url.absoluteString)
            }
        }
        UIImageView.currentTask = task
        task.resume()
    }
}
