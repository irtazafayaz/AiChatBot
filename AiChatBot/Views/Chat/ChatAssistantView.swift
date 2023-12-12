//
//  ChatAssistantView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 04/09/2023.
//

import SwiftUI

struct ChatAssistantView: View {
    
    @FetchRequest(
        entity: ChatHistory.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ChatHistory.createdAt, ascending: true)
        ],
        predicate: NSPredicate(format: "address == %@", UserDefaults.standard.loggedInEmail)
    ) var chatHistory: FetchedResults<ChatHistory>

    
    @State private var selectedText: String = ""
    @State private var selectedMessages: [MessageWithImages] = []
    @State private var moveToChatScreen: Bool = false
    @Environment(\.managedObjectContext) var moc
    
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
                HStack(spacing: 10) {
                    Button {
                        UserDefaults.standard.sessionID += 1
                        selectedMessages = [MessageWithImages(
                            id: UUID().uuidString,
                            content: .text("Act as an academic professor  and answer the questions in a detailed manner."),
                            createdAt: Date(),
                            role: .system,
                            sessionID: Double(UserDefaults.standard.sessionID)
                        )]
                        moveToChatScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_writing")
                                .padding(.top, 10)
                            Text("Scan Questions")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            Text("Your instant access to AI-powered answers.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                            
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    Button {
                        checkSubjectHistory(selectedSubject: "Math")
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_academic")
                                .padding(.top, 10)
                            Text("Scan Math")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            Text("Your AI math tutor at your fingertips.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                            
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
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
                
                HStack(spacing: 10) {
                    Button {
                        checkSubjectHistory(selectedSubject: "Geography")
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_summarize")
                                .padding(.top, 10)
                            Text("Geography")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Discover the world at your fingertips.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                            
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                        
                    }
                    
                    Button {
                        checkSubjectHistory(selectedSubject: "Physics")
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_world")
                                .padding(.top, 10)
                            Text("Physics")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Unravel the mysteries of the universe.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                }
                
                HStack(spacing: 10) {
                    Button {
                        checkSubjectHistory(selectedSubject: "Biology")
                    } label: {
                        VStack(alignment: .leading) {
                            Image("ic_assistant_plag")
                                .padding(.top, 10)
                            Text("Biology")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Explore the wonders of life's diversity.")
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(Color(hex: Colors.chatBG.rawValue)))
                    }
                    
                    Button {
                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Physics")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 10)
                            Text("Act as a physics expert.")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 1)
                            Spacer()
                        }
                        .frame(height: 226.0)
                        .frame(minWidth: 0, maxWidth: .infinity) // Equal width
                        .padding()
                        .background(RoundedCorners(
                            tl: 10,
                            tr: 10,
                            bl: 10,
                            br: 10
                        ).fill(.white))
                    }
                    
                }
            }
        }
        .padding(.horizontal, 10)
        .navigationDestination(isPresented: $moveToChatScreen, destination: {
            ChatView(messagesArr: selectedMessages)
        })
        
    }
    
    func checkSubjectHistory(selectedSubject: String) {
        if selectedSubject == "Math" {
            if UserDefaults.standard.mathID > 0 {
                convertDataToMessagesArray(forGroup: Double(UserDefaults.standard.mathID ))
                moveToChatScreen.toggle()
            } else {
                UserDefaults.standard.sessionID += 1
                UserDefaults.standard.mathID = UserDefaults.standard.sessionID
                selectedMessages = [MessageWithImages(
                    id: UUID().uuidString,
                    content: .text("Solve the following latex code and give a detailed elaboration of the solution in human read able form"),
                    createdAt: Date(),
                    role: .system,
                    sessionID: Double(UserDefaults.standard.sessionID)
                )]
                moveToChatScreen.toggle()
            }
        }
        else if selectedSubject == "Geography" {
            if UserDefaults.standard.geographyID > 0 {
                convertDataToMessagesArray(forGroup: Double(UserDefaults.standard.geographyID ))
                moveToChatScreen.toggle()
            } else {
                UserDefaults.standard.sessionID += 1
                UserDefaults.standard.geographyID = UserDefaults.standard.sessionID
                selectedMessages = [MessageWithImages(
                    id: UUID().uuidString,
                    content: .text("Act as a geographer."),
                    createdAt: Date(),
                    role: .system,
                    sessionID: Double(UserDefaults.standard.sessionID)
                )]
                moveToChatScreen.toggle()
            }
        }
        
        else if selectedSubject == "Physics" {
            if UserDefaults.standard.physicsID > 0 {
                convertDataToMessagesArray(forGroup: Double(UserDefaults.standard.physicsID ))
                moveToChatScreen.toggle()
            } else {
                UserDefaults.standard.sessionID += 1
                UserDefaults.standard.physicsID = UserDefaults.standard.sessionID
                selectedMessages = [MessageWithImages(
                    id: UUID().uuidString,
                    content: .text("Act as a physics expert."),
                    createdAt: Date(),
                    role: .system,
                    sessionID: Double(UserDefaults.standard.sessionID)
                )]
                moveToChatScreen.toggle()
            }
        }
        else if selectedSubject == "Biology" {
            if UserDefaults.standard.biologyID > 0 {
                convertDataToMessagesArray(forGroup: Double(UserDefaults.standard.biologyID ))
                moveToChatScreen.toggle()
            } else {
                UserDefaults.standard.sessionID += 1
                UserDefaults.standard.biologyID = UserDefaults.standard.sessionID
                selectedMessages = [MessageWithImages(
                    id: UUID().uuidString,
                    content: .text("Act as a biology expert."),
                    createdAt: Date(),
                    role: .system,
                    sessionID: Double(UserDefaults.standard.sessionID)
                )]
                moveToChatScreen.toggle()
            }
        }
    }
}

struct ChatAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAssistantView()
    }
}
