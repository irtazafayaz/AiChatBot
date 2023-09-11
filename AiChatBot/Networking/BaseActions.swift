//
//  BaseActions.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 08/09/2023.
//

import Foundation
import UIKit

protocol BaseActions {
    
    func registerUser(
        from movieEndPoint: ApiServiceEndPoint,
        params: [String: String],
        completion: @escaping (Result<RegisterResponse, ApiError>) -> ()
    )
    
    func login(
        from movieEndPoint: ApiServiceEndPoint,
        params: [String: String],
        completion: @escaping (Result<LoginResponse, ApiError>) -> ()
    )
    
    func logout(
        from movieEndPoint: ApiServiceEndPoint,
        refreshToken: String,
        completion: @escaping (Result<RegisterResponse, ApiError>) -> ()
    )
    
    func ocrWithImage(
        from movieEndPoint: ApiServiceEndPoint,
        image: UIImage,
        completion: @escaping (Result<OCRResponse, ApiError>) -> ()
    )
    
}
