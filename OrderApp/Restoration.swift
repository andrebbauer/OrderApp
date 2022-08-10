//
//  Restoration.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 10/08/22.
//

import Foundation

enum UserInfos: String {
    case order
    case controllerIdentifier
    case menuCategory
    case menuItem
}

enum StateRestorationController {
    
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories:
            return .categories
        case .menu:
            return .menu
        case .menuItemDetail:
            return .menuItemDetail
        case .order:
            return .order
        }
    }
    
    init?(userActivity: NSUserActivity) {
        guard let identifier = userActivity.controllerIdentifier
        else { return nil }
        
        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActivity.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActivity.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
}

extension NSUserActivity {
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?[UserInfos.order.rawValue] as? Data
            else { return nil }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        set {
            if let newValue = newValue,
               let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: [UserInfos.order.rawValue: jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
    
    var controllerIdentifier: StateRestorationController.Identifier? {
        get {
            if let controllerIdentifierString = userInfo?[UserInfos.controllerIdentifier.rawValue] as? String {
                return StateRestorationController.Identifier(rawValue: controllerIdentifierString)
            } else {
                return nil
            }
        }
        set {
            userInfo?[UserInfos.controllerIdentifier.rawValue] = newValue?.rawValue
        }
    }
    
    var menuCategory: String? {
        get {
            return userInfo?[UserInfos.menuCategory.rawValue] as? String
        }
        set {
            userInfo?[UserInfos.menuCategory.rawValue] = newValue
        }
    }
    
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?[UserInfos.menuItem.rawValue] as? Data
            else { return nil }
            
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        set {
            if let newValue = newValue,
               let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: [UserInfos.menuItem.rawValue: jsonData])
            } else {
                userInfo?[UserInfos.menuItem.rawValue] = nil
            }
        }
    }
    
}
