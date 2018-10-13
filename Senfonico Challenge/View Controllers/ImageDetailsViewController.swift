//
//  ImageDetailsViewController.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet weak var flickerImageView: UIImageView!
    
    var imageURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURLString = imageURLString, let url = URL(string: imageURLString) {
            flickerImageView.loadImage(withURL: url)
        }
    }

}
