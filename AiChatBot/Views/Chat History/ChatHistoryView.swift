//
//  ChatHistoryView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 04/09/2023.
//

import SwiftUI

struct ChatHistoryView: View {
    
    @FetchRequest(sortDescriptors: []) var chatHistory: FetchedResults<ChatHistory>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(chatHistory, id: \.self) { chat in
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
                            ChatHistoryCard(message: chat.message ?? "NaN", date: Utilities.formatDate(chat.createdAt ?? Date()) )
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
