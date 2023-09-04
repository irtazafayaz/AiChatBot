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
            
            /// This code will  be used in a separate file
            
            //            VStack {
            //                if viewModel.texts.isEmpty {
            //                    Text("Nothing Scanned Yet :D")
            //                } else {
            //                    List {
            //                        ForEach(viewModel.texts) { text in
            //                            NavigationLink(
            //                                destination: ScrollView { Text(text.content) },
            //                                label: { Text(text.content) }
            //                            )
            //                        }
            //                    }
            //                }
            //            }
            //            .navigationBarBackButtonHidden(true)
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    Button(action: {
            //                        viewModel.openCameraSheet = true
            //                    }, label: {
            //                        Image(systemName: "doc.text.viewfinder")
            //                    })
            //                    .sheet(isPresented: $viewModel.openCameraSheet, content: {
            //                        makeScannerView()
            //                    })
            //                }
            //            }
            
            VStack(alignment: .center) {
                TabView {
                    StartChatView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Chat")
                        }
                    ChatAssistantView()
                        .tabItem {
                            Image(systemName: "message")
                            Text("AI Assistants")
                        }
                    ChatHistoryView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("History")
                        }
                    Text("g")
                        .tabItem {
                            Image(systemName: "person")
                            Text("Account")
                        }
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Image("ic_app_logo_small")
                })
                ToolbarItem(placement: .principal, content: {
                    Text("Chatty AI")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: Colors.labelDark.rawValue))
                })
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeVM())
    }
}
