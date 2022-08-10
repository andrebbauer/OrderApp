//
//  UserActivityController.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 10/08/22.
//

import Foundation

struct UserActivityController {
    
    static var shared = UserActivityController()
    
    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")
    
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .categories, .order:
            return
        }
        
        userActivity.controllerIdentifier = controller.identifier
    }
}
