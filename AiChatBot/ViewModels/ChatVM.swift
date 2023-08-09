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
    
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var realTimeMessages = DataSource.messages
    
    func sendMessages(_ chatMessage: Message) {
        realTimeMessages.append(chatMessage)
        didChange.send(())
    }
    
}
