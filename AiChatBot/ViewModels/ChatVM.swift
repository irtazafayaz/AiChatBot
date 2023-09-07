//
//  ChatVM.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 06/06/2023.
//

import Foundation
import SwiftUI
import Combine

class ChatVM: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var msgsArr: [MessageWithImages] = []
    @Published var currentInput: String = ""
    @Published var scrollToTop: Bool = false
    @Published var isInteracting = false
    
    private let openAIService = OpenAIService()
    var updateSessionID: Bool

    init(with text: String, updateSessionID: Bool, messages: [Message] = []) {
        currentInput = text
        self.updateSessionID = updateSessionID
        self.messages = messages
    }
    
    func sendMessage(completion: @escaping (Bool) -> Void) {
        if currentInput.isEmpty {
            return
        }
        let newMessage = Message(id: UUID().uuidString, content: currentInput, createdAt: Date(), role: .user)
        messages.append(newMessage)
//        currentInput = ""
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
                            let newMessage = Message(id: newMessageResponse.id, content: messageContent, createdAt: Date(), role: .assistant)
                            self.messages.append(newMessage)
                            return
                        }
                        let newMessage = Message(id: newMessageResponse.id, content: self.messages[existingMessageIndex].content + messageContent, createdAt: Date(), role: .assistant)
                        self.messages[existingMessageIndex] = newMessage
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
    
    func addImage(selectedImage: UIImage) {
        
        
        
        
        
        print("AAAAAAAAAAAA")
    }
    
}
