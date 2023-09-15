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
            NSSortDescriptor(keyPath: \ChatHistory.createdAt, ascending: true)
        ]
    ) var chatHistory: FetchedResults<ChatHistory>
    
    @Environment(\.managedObjectContext) var moc
    @State private var moveToChatScreen: Bool = false
    @State private var fromChatHistory: Bool = true
    @State private var selectedMessages: [MessageWithImages] = []
    
    var groupedItems: [(Double, [ChatHistory])] {
        let groupedDictionary = Dictionary(grouping: chatHistory) { item in
            return item.sessionID
        }
        return groupedDictionary.sorted { $0.key < $1.key }
    }
    
    var uniqueGroups: [Double] {
        let groupSet = Set(chatHistory.compactMap { $0.sessionID })
        let sortedChatHistory = groupSet.sorted { $0 > $1 }
        return Array(sortedChatHistory)
    }
    
    func representativeItem(forGroup group: Double) -> ChatHistory? {
        return chatHistory.last { $0.sessionID == group }
    }
    
    func convertDataToMessagesArray(forGroup group: Double) {
        
        let chatArr = chatHistory.filter { $0.sessionID == group }
        if !chatArr.isEmpty {
            selectedMessages = chatArr.map {
                MessageWithImages(
                    id: UUID().uuidString,
                    content: ($0.message != nil) ? .text($0.message ?? "NaN") : .image($0.imageData!),
                    createdAt: $0.createdAt ?? Date(),
                    role: SenderRole(rawValue: $0.role ?? "NaN") ?? .paywall,
                    sessionID: $0.sessionID
                )
            }
        }
    }
    
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
                                    ChatHistoryCard(message: "\(group) - \(chat.message ?? "Image")", date: Utilities.formatDate(chat.createdAt ?? Date()) )
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
            ChatView(messagesArr: selectedMessages)
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
