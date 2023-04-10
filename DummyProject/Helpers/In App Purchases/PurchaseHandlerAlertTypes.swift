//
//  PurchaseHandlerAlertTypes.swift
//  Chamoji Face Filter
//
//  Copyright © 2019 Cappsule. All rights reserved.
//

import Foundation

//MARK: - Purchase Messages
enum PurchaseHandlerAlertTypes{
    case setProductIds
    case disabled
    case restored
    case purchased
    
    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}
