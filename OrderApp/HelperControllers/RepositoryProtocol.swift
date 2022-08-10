//
//  RepositoryProtocol.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import UIKit

protocol RepositoryProtocol {
    func fetch<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<Int, Error>) -> Void)
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void)
}
