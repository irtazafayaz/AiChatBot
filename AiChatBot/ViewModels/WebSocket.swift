//
//  WebSocket.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 11/09/2023.
//

import Foundation

class WebSocket: ObservableObject {
    
    @Published var messages = [String]()
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    init() {
        self.connect()
    }
    
    private func connect() {
        guard let url = URL(string: "ws://127.0.0.1:5000") else {
            return
        }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("data \(data)")
                case .string(let string):
                    print("string \(string)")
                @unknown default:
                    break
                }
            case .failure(let error):
                print("error \(error)")
            }
            
        })
    }
    
    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
