//
//  Image.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import Foundation

struct FlickerServerResponse: Codable {
    var photos: FlickerPhotos?
}

struct FlickerPhotos: Codable {
    var photo: [Image]?
}

struct Image: Codable {
    
    var urlString: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url_o"
        case title
    }
}
