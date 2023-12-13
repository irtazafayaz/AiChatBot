//
//  Crop.swift
//  AiChatBot
//
//  Created by Moeed Khan on 13/12/2023.
//

import SwiftUI

enum Crop: Equatable {
    case rectangle
    case square
    case custom(CGSize)
    
    func name()->String{
        switch self {
        case .rectangle:
            return "Rectangle"
        case .square:
            return "Square"
        case .custom(let cGSize):
            return "Custom \(Int(cGSize.width))X\(Int(cGSize.height))"
        }
    }
    
    func size()->CGSize{
        switch self {
        case .rectangle:
            return .init(width: 400, height: 300)
        case .square:
            return .init(width: 300, height: 300)
        case .custom(let cGSize):
            return cGSize
        }
    }
}
