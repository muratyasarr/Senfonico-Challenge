//
//  ImageTableViewCell.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var flickerImageView: UIImageView! {
        didSet {
            flickerImageView.layer.cornerRadius = 8.0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTitleLabel.text = nil
        flickerImageView.image = nil
        UIImageView.currentTask.cancel()
    }
}
