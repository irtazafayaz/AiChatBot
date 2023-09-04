//
//  Utilities.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 05/09/2023.
//

import Foundation


class Utilities {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy - hh:mm a"
        return dateFormatter
    }()
    
    static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

