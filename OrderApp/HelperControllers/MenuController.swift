//
//  MenuController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

typealias MinutesToPrepare = Int

struct MenuController: RepositoryProtocol {
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    static var order = Order() {
        didSet {
            NotificationCenter.default.post(name: orderUpdatedNotification, object: nil)
            UserActivityController.shared.userActivity.order = order
        }
    }
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func fetch<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let initialUrl = baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: initialUrl, resolvingAgainstBaseURL: true)!
        components.queryItems = endpoint.parameters
        let url = components.url!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let dataDecoded = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(dataDecoded))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError.badData))
            }
        }
        .resume()
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MinutesToPrepare, Error>) -> Void) {
        let endpoint = Endpoint.order
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let dataDecoded = try? JSONDecoder().decode(OrderResponse.self, from: data) {
                completion(.success(dataDecoded.prepTime))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NetworkError.badData))
            }
        }
        .resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

