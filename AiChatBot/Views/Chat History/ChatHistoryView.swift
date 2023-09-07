//
//  ChatHistoryView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 04/09/2023.
//

import SwiftUI

struct ChatHistoryView: View {
    
    @FetchRequest(
        entity: ChatHistory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ChatHistory.sessionID, ascending: true),
            NSSortDescriptor(keyPath: \ChatHistory.createdAt, ascending: true) // Sort by createdAt in descending order
        ]
    ) var chatHistory: FetchedResults<ChatHistory>
    
    @Environment(\.managedObjectContext) var moc
    @State private var moveToChatScreen: Bool = false
    @State private var fromChatHistory: Bool = true
    @State private var selectedMessages: [Message] = []
    
    var groupedItems: [(Double, [ChatHistory])] {
        let groupedDictionary = Dictionary(grouping: chatHistory) { item in
            return item.sessionID
        }
        return groupedDictionary.sorted { $0.key < $1.key }
    }
    
    var uniqueGroups: [Double] {
        let groupSet = Set(chatHistory.compactMap { $0.sessionID })
        return Array(groupSet)
    }
    
    func representativeItem(forGroup group: Double) -> ChatHistory? {
        return chatHistory.first { $0.sessionID == group } // Replace with your actual grouping attribute
    }
    
    func convertDataToMessagesArray(forGroup group: Double) {
        
        let chatArr = chatHistory.filter { $0.sessionID == group }
        if !chatArr.isEmpty {
            selectedMessages = chatArr.map {
                Message(
                    id: UUID().uuidString,
                    content: $0.message ?? "NaN",
                    createdAt: $0.createdAt ?? Date(),
                    role: SenderRole(rawValue: $0.role ?? "NaN") ?? .paywall
                )
            }
        }
    }
    
    
    
    //    var body: some View {
    //            List {
    //                ForEach(uniqueGroups, id: \.self) { group in
    //                    if let representativeItem = representativeItem(forGroup: group) {
    //                        Section(header: Text("Group: \(group)")) {
    //                            Text(representativeItem.message ?? "Unknown")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(uniqueGroups, id: \.self) { group in
                        if let chat = representativeItem(forGroup: group) {
                            Button {
                                convertDataToMessagesArray(forGroup: group)
                                moveToChatScreen.toggle()
                            } label: {
                                ZStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            delete(at: IndexSet(integer: chatHistory.firstIndex(of: chat)!))
                                        } label: {
                                            Image("ic_delete")
                                                .foregroundColor(.white)
                                                .padding(10)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(RoundedCorners(
                                        tl: 10,
                                        tr: 10,
                                        bl: 10,
                                        br: 10
                                    ).fill(Color(hex: "#F75555")))
                                    ChatHistoryCard(message: "\(chat.sessionID) - \(String(describing: chat.message))", date: Utilities.formatDate(chat.createdAt ?? Date()) )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 10)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                HStack {
                    CustomBackButton()
                    Text("History")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: "#FFFFFF"))
                }
            })
        }
        .navigationDestination(isPresented: $moveToChatScreen, destination: {
            ChatView(viewModel: ChatVM(with: "", updateSessionID: true, messages: selectedMessages))
        })
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let language = chatHistory[index]
            moc.delete(language)
        }
        do {
            try moc.save()
        } catch  {
            print("> Error occured during deleting from core data")
        }
    }
}

struct ChatHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHistoryView()
    }
}
