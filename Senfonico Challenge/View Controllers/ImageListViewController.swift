//
//  ViewController.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit


class ImageListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 140.0
        }
    }
    
    var images: [Image] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareData()
    }
    
    private func prepareUI() {
        title = "Photos"
    }
    
    private func prepareData() {
        Webservice().request(ImagesEndpoint.all) { [weak self] (result: Result<FlickerServerResponse>) in
            switch result {
            case .success(let flickerServerResponse):
                self?.images = flickerServerResponse.photos?.photo?.filter({$0.urlString != nil }) ?? []
                print("successss")
            case .error(let error):
                print("errorr: \(error.localizedDescription)")
            }
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        let image = images[indexPath.row]
        cell.imageTitleLabel.text = image.title
        if let imageURLString = image.urlString {
            guard let url = URL(string: imageURLString) else { return UITableViewCell() }
            cell.flickerImageView.loadImage(withURL: url)
        }
        return cell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        guard let imageDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: ImageDetailsViewController.self)) as? ImageDetailsViewController else { return }
        imageDetailsVC.imageURLString = image.urlString
        self.navigationController?.pushViewController(imageDetailsVC, animated: true)
    }
}
