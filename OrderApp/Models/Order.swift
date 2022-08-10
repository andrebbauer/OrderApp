//
//  Order.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
