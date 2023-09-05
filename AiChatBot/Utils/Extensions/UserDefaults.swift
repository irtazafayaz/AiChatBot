//
//  UserDefaults.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 05/09/2023.
//

import Foundation

extension UserDefaults {
    
    var chatCount: Int {
        get {
            UserDefaults.standard.integer(forKey: "chatCount")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "chatCount")
        }
    }
    
    var isProMemeber: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isProMemeber")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isProMemeber")
        }
    }
    var subscriptionDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "subscriptionDate") as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "subscriptionDate")
        }
    }
    
    var expiryDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "expiryDate") as? Date
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "expiryDate")
        }
    }
    var subscriptionType: String? {
        get {
            UserDefaults.standard.string(forKey: "subscriptionType")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "subscriptionType")
        }
    }
    
    
}
