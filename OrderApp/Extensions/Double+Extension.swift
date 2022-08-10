//
//  Double+Extension.swift
//  OrderApp
//
//  Created by Andre Barbosa Carneiro Da Cunha Bauer on 05/08/22.
//

import Foundation

extension Double {
    
    var currency: String {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.currencySymbol = "R$"
        return priceFormatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}
