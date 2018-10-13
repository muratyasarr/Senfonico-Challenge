//
//  NetworkManager.swift
//  Senfonico Challenge
//
//  Created by Guest User on 13.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

// Types
enum Result<T> {
    case success(T)
    case error(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void

enum NetworkStackError: Error {
    case invalidRequest
    case dataMissing
}


// Webservice

protocol WebserviceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>)
}

class Webservice: WebserviceProtocol {
    
    private let urlSession: URLSession
    private let parser: Parser
    
    init(urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.urlSession = urlSession
        self.parser = Parser()
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping ResultCallback<T>) {
        
        guard let request = endpoint.request else {
            OperationQueue.main.addOperation({ completion(.error(NetworkStackError.invalidRequest)) })
            return
        }
        
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                OperationQueue.main.addOperation({ completion(.error(error)) })
                return
            }
            
            guard let data = data else {
                OperationQueue.main.addOperation({ completion(.error(NetworkStackError.dataMissing)) })
                return
            }
            self.parser.json(data: data, completion: completion)
        }
        
        task.resume()
    }
}

struct Parser {
    let jsonDecoder = JSONDecoder()
    
    func json<T: Decodable>(data: Data, completion: @escaping ResultCallback<T>) {
        do {
            let result: T = try jsonDecoder.decode(T.self, from: data)
            OperationQueue.main.addOperation { completion(.success(result)) }
            
        } catch let parseError {
            OperationQueue.main.addOperation { completion(.error(parseError)) }
        }
    }
}


// Endpoint
protocol Endpoint {
    var request: URLRequest? { get }
    var httpMethod: String { get }
    var queryItems: [URLQueryItem]? { get }
    var scheme: String { get }
    var host: String { get }
}

extension Endpoint {
    func request(forPath path: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
}

// ImagesEndpoint
enum ImagesEndpoint {
    case all
}

extension ImagesEndpoint: Endpoint {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.flickr.com"
    }
    
    var request: URLRequest? {
        switch self {
        case .all:
            return request(forPath: "/services/rest/")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .all:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .all:
            return [
                URLQueryItem(name: "method", value: "flickr.galleries.getPhotos"),
                URLQueryItem(name: "gallery_id", value: "72157621980433950"),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1"),
                URLQueryItem(name: "api_key", value: "b05a2762ecc0851ca51abcaed20c9b30"),
                URLQueryItem(name: "extras", value: "url_o")
            ]
        }
    }
}
