//
//  CoordinatorProtocols.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 06/08/22.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol CategoryCoordinatorDelegate: AnyObject {
    func selectedCategory(_ category: String)
}

protocol MenuCoordinatorDelegate: AnyObject {
    func selected(_ item: MenuItem, image: UIImage?)
}

protocol MenuItemDetailDelegate: AnyObject {
    func orderedItem()
}

protocol OrderTableViewDelegate: AnyObject {
    func submitOrder(minutesToPrepare: MinutesToPrepare)
}
