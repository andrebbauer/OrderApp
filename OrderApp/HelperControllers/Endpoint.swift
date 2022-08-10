//
//  Endpoint.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import Foundation

enum Endpoint {
    case categories
    case menu(String)
    case order
    
    var scheme: String {
        "http"
    }
    
    var baseURL: String {
        "localhost:8080/"
    }
    
    var path: String {
        switch self {
        case .categories:
            return "categories"
        case .menu:
            return "menu"
        case .order:
            return "order"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .menu(let category):
            return [URLQueryItem(name: "category", value: category)]
        default:
            return []
        }
    }
    
    var method: String {
        switch self {
        case .categories, .menu:
            return "GET"
        case .order:
            return "POST"
        }
    }
    
}
