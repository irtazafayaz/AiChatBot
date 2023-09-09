//
//  ResponseMode;.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 08/09/2023.
//

import Foundation

struct RegisterResponse: Decodable {
    let message: String
}

struct LoginResponse: Decodable {
    let refreshToken: String
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}


