//
//  ViewController.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Webservice().request(ImagesEndpoint.all) { (result: Result<FlickerServerResponse>) in
            switch result {
            case .success(let flickerServerResponse):
                print("successss")
            case .error(let error):
                print("errorr: \(error.localizedDescription)")
            }
        }
    }
}

