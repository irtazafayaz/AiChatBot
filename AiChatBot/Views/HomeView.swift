//
//  HomeView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 29/05/2023.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeVM
    @FetchRequest(sortDescriptors: []) var chatHistory: FetchedResults<ChatHistory>

    init(viewModel: HomeVM) {
        self.viewModel = viewModel
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completionHandler: { textPerPage in
            if let output = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: output)
                self.viewModel.texts.append(newScanData)
            }
            self.viewModel.openCameraSheet = false
        })
    }
    
    var body: some View {
            VStack(alignment: .center) {
                TabView {
                    StartChatView()
                        .tabItem {
                            Image("ic_tab_chat")
                            Text("Chat")
                        }
                    ChatAssistantView()
                        .tabItem {
                            Image("ic_tab_assistant")
                            Text("AI Assistants")
                        }
                    ChatHistoryView()
                        .tabItem {
                            Image("ic_tab_history")
                            Text("History")
                        }
                    ProfileView()
                        .tabItem {
                            Image("ic_tab_people")
                            Text("Account")
                        }
                }
                .accentColor(Color(hex: Colors.primary.rawValue))
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Image("ic_app_logo_small")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                })
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeVM())
    }
}
