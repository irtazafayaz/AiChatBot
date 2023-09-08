//
//  BaseActions.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 08/09/2023.
//

import Foundation

protocol BaseActions {
    
    func registerUser(from movieEndPoint: ApiServiceEndPoint, params: [String: String], completion: @escaping (Result<RegisterResponse, ApiError>) -> ())
    
}
