//
//  PDFView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 08/06/2023.
//

import SwiftUI

struct PDFView: View {
    
    let text: String
    
    var body: some View {
        
        VStack {
            Text("School AI")
            Text(text)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(.max)
                .padding(.top)
                .padding(.horizontal, 30)
        }
        .padding()
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        PDFView(text: "assadjnsadjas dajshdkjashdkja dhasjkhdjkasgkd")
    }
}
