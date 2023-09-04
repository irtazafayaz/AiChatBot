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

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let language = chatHistory[index]
            moc.delete(language)
        }
        
        do {
            try moc.save()
        } catch {
            // handle the Core Data error
        }
        
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(chatHistory, id: \.self) { chat in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(chat.message ?? "No Response")")
                                    .font(Font.custom(FontFamily.semiBold.rawValue, size: 18))
                                    .foregroundColor(Color(hex: Colors.labelDark.rawValue))
                                Text(Utilities.formatDate(chat.createdAt ?? Date()))
                                    .font(Font.custom(FontFamily.regular.rawValue, size: 10))
                                    .foregroundColor(Color(hex: Colors.labelGray.rawValue))
                                    .padding(.top, 2)
                            }
                            Spacer()
                            Image("ic_arrow_right")
                        }
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                        
                    }
                    .onDelete(perform: delete)
                }
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 10)
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading, content: {
//                HStack {
//                    CustomBackButton()
//                    Text("BROO")
//                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
//                        .foregroundColor(Color(hex: "#FFFFFF"))
//                }
//            })
//        }
    }
}

struct ChatHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHistoryView()
    }
}
