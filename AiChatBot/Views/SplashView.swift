//
//  SplashView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("ic_app_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160) 
            
            Text("ChattyAI")
                .font(Font.custom("Urbanist-Bold", size: 40))
                .foregroundColor(Color(hex: "#212121"))
                .multilineTextAlignment(.center)
                .frame(width: 164, height: 64)
            
            Spacer()
            
            Image("ic_loading")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(.bottom,50)
        }

    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
