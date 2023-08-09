//
//  ChatView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 06/06/2023.
//

import SwiftUI
import PDFKit

struct ChatView: View {
    
    @State var typingMessage: String = ""
    @EnvironmentObject var chatVM: ChatVM
    @State private var isEditing: Bool = false
    @State private var convoStarted: Bool = false
    
    @State private var text: String = ""
    
    func sendMessage() {
        if !typingMessage.isEmpty {
            chatVM.sendMessages(Message(content: typingMessage, user: DataSource.secondUser))
            typingMessage = ""
            convoStarted = true
        }
    }
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if convoStarted {
                    List {
                        ForEach(chatVM.realTimeMessages, id: \.self) { msg in
                            MessageView(currentMessage: msg)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    
                } else {
                    
                    Image("ic_app_logo_gray")
                        .padding(.top, 50)
                    
                    Text("Capabilities")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: "BDBDBD"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    
                    
                    VStack {
                        Text("Answer all your questions.\n(Just ask me anything you like!)")
                            .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                            .foregroundColor(Color(hex: "9E9E9E"))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedCorners(
                                tl: 10,
                                tr: 10,
                                bl: 10,
                                br: 10
                            ).fill(Color(hex: Colors.chatBG.rawValue)))
                        
                        Text("Generate all the text you want.\n(essays, articles, reports, stories, & more)")
                            .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                            .foregroundColor(Color(hex: "9E9E9E"))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedCorners(
                                tl: 10,
                                tr: 10,
                                bl: 10,
                                br: 10
                            ).fill(Color(hex: Colors.chatBG.rawValue)))
                        
                        Text("Conversational AI.\n(I can talk to you like a natural human)")
                            .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                            .foregroundColor(Color(hex: "9E9E9E"))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedCorners(
                                tl: 10,
                                tr: 10,
                                bl: 10,
                                br: 10
                            ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    .padding()
                    
                    
                    Text("These are just a few examples of what I can do.")
                        .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                        .foregroundColor(Color(hex: "9E9E9E"))
                    
                    Spacer()
                }
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                HStack {
                    TextField("Message...", text: $typingMessage, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .padding()
                    .frame(minHeight: CGFloat(30))
                    .background(Color(hex: isEditing ? "#1417CE92" : Colors.chatBG.rawValue))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEditing ? Color(hex: Colors.primary.rawValue) : Color.clear, lineWidth: 2)
                    )
                    .onChange(of: typingMessage) { newValue in
                        if newValue.isEmpty && !isEditing {
                            typingMessage = ""
                            // Reset any other state variables or perform additional actions
                        }
                    }
                    Button(action: sendMessage) {
                        Image("ic_send_btn_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }
                .frame(minHeight: CGFloat(50))
                .padding()
                .padding(.bottom, 20)
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
            .navigationBarTitle("Chatty AI", displayMode: .inline)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}




