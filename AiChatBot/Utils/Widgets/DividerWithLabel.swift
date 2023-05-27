//
//  DividerWithLabel.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 26/05/2023.
//

import Foundation
import SwiftUI

struct DividerWithLabel: View {
    
    let label: String
    let padding: CGFloat
    let color: Color
    
    init(label: String, padding: CGFloat = 0, color: Color = .gray) {
        self.label = label
        self.padding = padding
        self.color = color
    }
    var body: some View {
        
        HStack {
            dividerLine
            Text(label).foregroundColor(color)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: true, vertical: false)
            dividerLine
        }
    }
    private var dividerLine: some View {
        return VStack { Divider().background(color) }.padding(padding)
    }
}
