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
    private let service = BaseService.shared
    
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
    
    func sendImage(image: UIImage, completion: @escaping (MessageWithImages?) -> Void) {
        service.ocrWithImage(from: .ocr, image: image, completion: { [weak self] response in
            print(response)
            guard self != nil else { return }
            switch response {
            case .success(let response):
                completion(MessageWithImages(id: UUID().uuidString, content: .text(response.gptResponse), createdAt: Date(), role: .assistant))
            case .failure(let error):
                print("GPT ERROR \(error)")
                completion(nil)
            }
        })
    }
    
    
    func sendMessageUsingFirebase(completion: @escaping (MessageWithImages?) -> Void) {
        if currentInput.isEmpty {
            return
        }
        let filteredMsgs = mapToMessages(msgsArr)
        let messagesDescription = filteredMsgs.map { message in
            return message.description
        }
        let data = ["chat_history": messagesDescription]
        service.askGPT(from: .gptText, history: data) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let response):
                let msg = MessageWithImages(id: UUID().uuidString, content: .text(response.gptResponse), createdAt: Date(), role: .assistant)
                self.msgsArr.append(msg)
                completion(msg)
            case .failure(let error):
                print("> GPT ERROR \(error)")
                completion(nil)
            }
        }
    }
    
    
    func mapToMessages(_ messagesWithImages: [MessageWithImages]) -> [MessageData] {
        return messagesWithImages.map { messageWithImages in
            switch messageWithImages.content {
            case .text(let textContent):
                return MessageData(
                    id: messageWithImages.id,
                    role: messageWithImages.role,
                    content: textContent
                )
            case .image:
                return MessageData(
                    id: messageWithImages.id,
                    role: messageWithImages.role,
                    content: "Image Content"
                )
            }
        }
    }
    
    
    
}
