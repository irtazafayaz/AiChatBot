//
//  AiChatBotApp.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI
import RevenueCat

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
       
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Constants.revenueCat)
        Utilities.updateSubscription()
        UserDefaults.standard.register(defaults: ["showDemo": true])
        UserDefaults.standard.register(defaults: ["skipDemo": false])
        return true
        
    }
}

@main
struct AiChatBotApp: App {
    
    @State private var showSplashScreen = true
    @StateObject var userViewModel = UserViewModel()
    @StateObject private var dataController = DataController()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplashScreen = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(userViewModel)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
    }
}
