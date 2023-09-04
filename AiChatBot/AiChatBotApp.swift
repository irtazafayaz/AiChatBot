//
//  AiChatBotApp.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI

@main
struct AiChatBotApp: App {
    
    @State private var showSplashScreen = true
    @StateObject var userViewModel = UserViewModel()

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
            }
        }
    }
}
