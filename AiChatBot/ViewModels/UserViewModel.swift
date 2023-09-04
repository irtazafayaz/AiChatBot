//
//  UserViewModel.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 10/08/2023.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false

    init() {
//        Purchases.shared.getCustomerInfo { (customerInfo, error) in
//            self.isSubscriptionActive = customerInfo?.entitlements.all["pro"]?.isActive == true
//        }
    }
    
    func checkIfSubscribed(completion: @escaping (Bool) -> Void) {
        completion(true)
//        Purchases.shared.getCustomerInfo { (customerInfo, error) in
//            if customerInfo?.entitlements.all["pro"]?.isActive == true {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
    }
    
    
}
