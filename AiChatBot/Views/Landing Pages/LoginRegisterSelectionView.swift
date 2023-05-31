//
//  LoginRegisterSelectionView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 26/05/2023.
//

import SwiftUI

struct LoginRegisterSelectionView: View {
    var body: some View {
        VStack {
            Image("ic_app_logo")
            
            VStack {
                Text("Welcome to")
                    .font(Font.custom("Urbanist-Bold", size: 40))
                    .foregroundColor(Color(hex: "#212121"))
                
                Text("ChattyAI 👋")
                    .font(Font.custom("Urbanist-Bold", size: 40))
                    .foregroundColor(Color(hex: "#17CE92"))
            }
            
            NavigationLink(destination: LoginView(viewModel: LoginVM())) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(Color(hex: "#17CE92"))
                        .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                        .frame(height: 65)
                        .padding()
                    
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            }
            
            NavigationLink(destination: RegisterView(viewModel: RegisterUserVM())) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(Color(hex: "#E8FAF4"))
                        .frame(height: 65)
                        .padding()
                    
                    Text("Sign up")
                        .foregroundColor(Color(hex: "#17CE92"))
                        .font(.system(size: 18, weight: .bold))
                }
                .frame(maxWidth: .infinity)
            }
            
            DividerWithLabel(label: "or continue with")
                .padding(.top, 20)
            
            
            HStack(alignment: .center) {
                Image("ic_facebook")
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
}

struct LoginRegisterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterSelectionView()
    }
}
