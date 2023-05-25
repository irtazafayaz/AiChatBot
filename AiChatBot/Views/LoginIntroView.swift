//
//  LoginIntroView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI

struct LoginIntroView: View {
    
    @State private var isLoginViewPresented = false
    @State private var showLoginPage: Bool = false
    
    var body: some View {
        VStack {
            Image("ic_loginintro")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 400)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [Color.clear, Color.white.opacity(1)]
                        ),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            Text("The best AI Chatbot app in this century")
                .font(Font.custom("Urbanist-Bold", size: 32))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor...")
                .font(Font.custom("Urbanist-Regular", size: 18))
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: LoginView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(Color(hex: "#17CE92"))
                        .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                        .frame(width: 183, height: 65)
                        .padding()
                    
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            
        }
        .background(Color.white)
        .overlay(
            Group {
                if showLoginPage {
                    LoginView()
                        .transition(.move(edge: .bottom))
                }
            }
        )
    }
}

struct LoginIntroView_Previews: PreviewProvider {
    static var previews: some View {
        LoginIntroView()
    }
}

