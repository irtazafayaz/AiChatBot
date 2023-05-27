//
//  LoginView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var isAgreed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Welcome back 👋")
                .font(Font.custom("Urbanist-Bold", size: 32))
                .frame(alignment: .leading)
            
            Text("Please enter your email & password to log in.")
                .font(Font.custom("Urbanist-Regular", size: 18))
                .multilineTextAlignment(.leading)
                .padding(.top, 10)
                .lineLimit(2)
            
            // MARK: Email Text Field
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                HStack {
                    TextField("Email", text: $email)
                    Image("ic_dropdown")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 20)
                .underlinedTextFieldStyle()
            }
            .padding(.top, 10)
            
            // MARK: Password Text Field
            VStack(alignment: .leading) {
                Text("Password")
                    .font(.headline)
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color(hex: "#17CE92"))
                    }
                }
                .padding(.bottom, 20)
                .underlinedTextFieldStyle()
            }
            .padding(.top, 10)
            
            // MARK: CheckBox Agreement
            HStack {
                Button(action: {
                    isAgreed.toggle()
                }) {
                    Image(systemName: isAgreed ? "checkmark.square.fill" : "square")
                        .foregroundColor(isAgreed ? .green : .gray)
                }
                Text("Remember me")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(nil)
            }
            .padding(.top, 10)
            
            
            Divider()
                .padding(.top, 20)
            
            
            HStack(alignment: .center) {
                Text("Don't have an account?")
                Button(action: {
                    
                }, label: {
                    Text("Signup")
                        .foregroundColor(Color(hex: "#17CE92"))
                })
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
            
            
            DividerWithLabel(label: "or continue with")
                .padding(.top, 20)
            
            
            HStack(alignment: .center) {
                Image("ic_facebook")
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
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
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
            }
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
        
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


