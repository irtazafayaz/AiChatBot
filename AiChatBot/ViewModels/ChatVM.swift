//
//  ChatVM.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 06/06/2023.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class ChatVM: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var msgsArr: [MessageWithImages] = []
    @Published var currentInput: String = ""
    @Published var scrollToTop: Bool = false
    @Published var isInteracting = false
    @Published var updateSessionID = true
    
    @FetchRequest(sortDescriptors: []) var chatHistory: FetchedResults<ChatHistory>
    private let openAIService = OpenAIService()

    init(with text: String, messages: [MessageWithImages] = []) {
        currentInput = text
        self.msgsArr = messages
    }
    
    func sendMessageApi(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let newMessage = MessageWithImages(id: UUID().uuidString, content: .text(self.currentInput), createdAt: Date(), role: .user)
            DispatchQueue.main.async {
                self.msgsArr.append(newMessage)
                completion(true)
            }
        }
    }

    
    func sendMessage(completion: @escaping (Bool) -> Void) {
        if currentInput.isEmpty {
            return
        }
        let newMessage = MessageWithImages(id: UUID().uuidString, content: .text(currentInput), createdAt: Date(), role: .user)
        msgsArr.append(newMessage)
        openAIService.sendStreamMessages(messages: messages).responseStreamString { [weak self] stream in
            guard let self = self else { return }
            switch stream.event {
            case .stream(let response):
                switch response {
                case .success(let string):
                    let streamResponse = self.parseStreamData(string)
                    print(streamResponse)
                    print(self.messages)
                    streamResponse.forEach { newMessageResponse in
                        guard let messageContent = newMessageResponse.choices.first?.delta.content else {
                            return
                        }
                        guard let existingMessageIndex = self.messages.lastIndex(where: {$0.id == newMessageResponse.id}) else {
                            let newMessage = MessageWithImages(id: newMessageResponse.id, content: .text(messageContent), createdAt: Date(), role: .assistant)
                            self.msgsArr.append(newMessage)
                            return
                        }
                        let newMessage = MessageWithImages(id: newMessageResponse.id, content: .text(self.messages[existingMessageIndex].content + messageContent), createdAt: Date(), role: .assistant)
                        self.msgsArr[existingMessageIndex] = newMessage
                    }
                case .failure(_):
                    print("/ChatVM/sendMessage/sendStreamMessage/Failure")
                    completion(false)
                }
            case .complete(_):
                print("COMPLETE")
                scrollToTop.toggle()
                completion(true)
            }
        }
    }
    
    
    func parseStreamData(_ data: String) -> [ChatStreamCompletionResponse] {
        let responseString = data.split(separator: "data:").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({!$0.isEmpty})
        let jsonDecoder = JSONDecoder()
        return responseString.compactMap { jsonString in
            guard let jsonData = jsonString.data(using: .utf8), let streamResponse = try? jsonDecoder.decode(ChatStreamCompletionResponse.self, from: jsonData) else {
                return nil
            }
            return streamResponse
        }
    }

    func getMessageObject() {
        if updateSessionID {
            if msgsArr.isEmpty {
                UserDefaults.standard.sessionID += 1
            }
            updateSessionID = false
        }
    }


    
}
