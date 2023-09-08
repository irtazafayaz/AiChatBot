//
//  Utilities.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 05/09/2023.
//

import Foundation
import RevenueCat
import SwiftUI

class Utilities {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy - hh:mm a"
        return dateFormatter
    }()
    
    static let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func updateSubscription() {
        Purchases.shared.getCustomerInfo { cust, error in
           _ = updateCustumerInCache(cust: cust)
        }
    }
    static func updateCustumerInCache(cust: CustomerInfo?) -> Bool {
        UserDefaults.standard.isProMemeber = cust?.entitlements["pro"]?.isActive == true
        UserDefaults.standard.subscriptionDate = cust?.entitlements["pro"]?.latestPurchaseDate
        UserDefaults.standard.expiryDate = cust?.entitlements["pro"]?.expirationDate
        UserDefaults.standard.subscriptionType = cust?.entitlements["pro"]?.productIdentifier ?? ""
        return cust?.entitlements["pro"]?.isActive == true
    }
    
}

