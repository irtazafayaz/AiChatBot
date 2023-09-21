//
//  ChatAssistantView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 04/09/2023.
//

import SwiftUI

struct ChatAssistantView: View {
    
    @State private var selectedText: String = ""
    @State private var selectedMessages: [MessageWithImages] = []
    @State private var moveToChatScreen: Bool = false
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        VStack {
            ScrollView {
                HStack(spacing: 20) {
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer who excels in writing on articles."),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_writing")
                                .padding(.top, 10)
                            Text("Write an Articles")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            Text("Generate well-written articles on any topic you want.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer"),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_academic")
                                .padding(.top, 10)
                            Text("Academic Writer")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            Text("Generate educational writing such as essays, reports, etc.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    
                }
                .padding(.top, 40)
                
                HStack(spacing: 20) {
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer"),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_summarize")
                                .padding(.top, 10)
                            Text("Summarize (TL;DR)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Extract key points from long texts.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                        
                    }
                    
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer"),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_world")
                                .padding(.top, 10)
                            Text("Translate Language")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Translate from one language to another.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                }
                .padding(.top, 10)
                
                HStack(spacing: 20) {
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer"),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_plag")
                                .padding(.top, 10)
                            Text("Plagiarism Checker")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Check the level of text plagiarism with AI.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    .frame(height: 226.0)
                    
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as a writer"),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_academic")
                                .padding(.top, 10)
                            Text("Academic Writer")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            Text("Generate educational writing such as essays, reports, etc.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 5)
                        }
                        .frame(height: 226.0)
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 10)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                HStack {
                    CustomBackButton()
                    Text("School AI")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: "#FFFFFF"))
                }
            })
        }
        .navigationDestination(isPresented: $moveToChatScreen, destination: {
            ChatView(messagesArr: selectedMessages)
        })
        
    }
}

struct ChatAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAssistantView()
    }
}
