//
//  RegisterView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 26/05/2023.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject private var viewModel: RegisterUserVM
    
    init(viewModel: RegisterUserVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Hello There 👋")
                .font(Font.custom("Urbanist-Bold", size: 32))
                .frame(alignment: .leading)
            
            ScrollView {
                
                Text("Please enter your email & password to create an account.")
                    .font(Font.custom("Urbanist-Regular", size: 18))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .lineLimit(2)
                
                // MARK: Email Text Field
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.headline)
                    HStack {
                        TextField("Email", text: $viewModel.email)
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
                        if viewModel.isPasswordVisible {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                        Button(action: {
                            viewModel.isPasswordVisible.toggle()
                        }) {
                            Image(systemName: viewModel.isPasswordVisible ? "eye.fill" : "eye.slash.fill")
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
                        viewModel.isAgreed.toggle()
                    }) {
                        Image(viewModel.isAgreed ? "ic_checkbox_filled" : "ic_checkbox")
                            .foregroundColor(viewModel.isAgreed ? .green : .gray)
                    }
                    Text("I agree to ChattyAI Public Agreement, Terms, & Privacy Policy.")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .lineLimit(3)
                        .onTapGesture {
                            // Open the link here
                            //openLink()
                        }
                }
                .padding(.top, 10)
                
                Divider()
                    .padding(.top, 20)
                
                NavigationLink(destination: LoginView(viewModel: LoginVM())) {
                    HStack(alignment: .center) {
                        Text("Already Have an account?")
                            .font(Font.custom("Urbanist-Medium", fixedSize: 16))
                            .foregroundColor(Color(hex: "#212121"))
                        Text("Login")
                            .font(Font.custom("Urbanist-Bold", fixedSize: 16))
                            .foregroundColor(Color(hex: "#17CE92"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                }
                
                DividerWithLabel(label: "or continue with")
                    .padding(.top, 20)
                
                
                HStack(alignment: .center) {
                    Image("ic_facebook")
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                
                
            }
            NavigationLink(destination: CompleteYourProfileView(viewModel: viewModel)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .foregroundColor(Color(hex: "#17CE92"))
                        .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                        .frame(height: 65)
                        .padding()
                    
                    Text("Continue ")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            
        }
        .ignoresSafeArea()
        .padding(.horizontal)
        .padding(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterUserVM())
    }
}
