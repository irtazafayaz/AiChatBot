//
//  ContentView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI
import PDFKit
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            if UserDefaults.standard.rememberMe {
                HomeView(viewModel: HomeVM())
            } else {
                LoginIntroView()
            }
        }
    }
}
