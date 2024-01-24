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
    
    var sessionID: Int {
        get {
            UserDefaults.standard.integer(forKey: "sessionID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "sessionID")
        }
    }
    
    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: "refresh_token")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "refresh_token")
        }
    }
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "access_token")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "access_token")
        }
    }
    
    var rememberMe: Bool {
        get {
            UserDefaults.standard.bool(forKey: "remember_me")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "remember_me")
        }
    }
    
    var loggedInEmail: String {
        get {
            UserDefaults.standard.string(forKey: "logged_in_email") ?? "NaN"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "logged_in_email")
        }
    }
    
    var fullName: String {
        get {
            UserDefaults.standard.string(forKey: "full_name") ?? "NaN"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "full_name")
        }
    }
    
    var maxTries: Int {
        get {
            UserDefaults.standard.integer(forKey: "max_tries")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "max_tries")
        }
    }
    
    var mathID: Int {
        get {
            UserDefaults.standard.integer(forKey: "mathID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "mathID")
        }
    }
    
    var geographyID: Int {
        get {
            UserDefaults.standard.integer(forKey: "geographyID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "geographyID")
        }
    }
    
    var physicsID: Int {
        get {
            UserDefaults.standard.integer(forKey: "physicsID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "physicsID")
        }
    }
    
    var biologyID: Int {
        get {
            UserDefaults.standard.integer(forKey: "biologyID")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "biologyID")
        }
    }
    
    var showDemo: Bool {
        get {
            UserDefaults.standard.bool(forKey: "showDemo")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "showDemo")
        }
    }
    
    var skipDemo: Bool {
        get {
            UserDefaults.standard.bool(forKey: "skipDemo")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "skipDemo")
        }
    }
}
