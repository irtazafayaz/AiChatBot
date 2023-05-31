//
//  CompleteYourProfileView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 26/05/2023.
//

import SwiftUI
import iPhoneNumberField
import UIKit

struct CompleteYourProfileView: View {
    
    @ObservedObject private var viewModel: RegisterUserVM
    
    init(viewModel: RegisterUserVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Complete your profile 📋")
                .font(Font.custom("Urbanist-Bold", size: 32))
                .frame(alignment: .leading)
            
            ScrollView {
                
                Text("Please enter your profile. Don't worry, only you can see your personal data. No one else will be able to see it. Or you can skip it for now.")
                    .font(Font.custom("Urbanist-Regular", size: 18))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .lineLimit(5)
                
                HStack (alignment: .center) {
                    RoundedIconWithEditButton(imageName: "ic_avatar")
                }
                .frame(maxWidth: .infinity)
                
                // MARK: Full Name Text Field
                
                VStack(alignment: .leading) {
                    Text("Full Name")
                        .foregroundColor(Color(hex: "#212121"))
                        .font(Font.custom("Urbanist-Bold", size: 16))
                    HStack {
                        TextField("Full Name", text: $viewModel.fullName)
                            .foregroundColor(viewModel.fullName.isEmpty ? Color(hex: "#9E9E9E") : Color(hex: "#212121"))
                            .font(Font.custom("Urbanist-Bold", size: 20))
                        
                    }
                    .padding(.bottom, 20)
                    .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
                // MARK: Phone Number Text Field
                
                VStack(alignment: .leading) {
                    Text("Phone Number")
                        .foregroundColor(Color(hex: "#212121"))
                        .font(Font.custom("Urbanist-Bold", size: 16))
                    iPhoneNumberField("(000) 000-0000", text: $viewModel.phoneNumber) { field in
                        field.textColor = UIColor(Color(hex: "#212121"))
                        field.font = UIFont(name: "Urbanist-Bold", size: 20)
                    }
                    .flagHidden(false)
                    .flagSelectable(true)
                    .padding(.bottom, 10)
                    .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
                // MARK: Gender
                
                VStack(alignment: .leading) {
                    Text("Gender")
                        .foregroundColor(Color(hex: "#212121"))
                        .font(Font.custom("Urbanist-Bold", size: 16))
                    Menu(viewModel.selectedGender.isEmpty ? "Gender" : viewModel.selectedGender, content: {
                        ForEach(self.viewModel.genders, id: \.self, content: { gender in
                            Button(action: {
                                viewModel.selectedGender = gender
                            }) {
                                Label(gender, systemImage: "person")
                            }
                        })
                    })
                    .foregroundColor(viewModel.selectedGender.isEmpty ? Color(hex: "#9E9E9E") : Color(hex: "#212121"))
                    .font(Font.custom("Urbanist-Bold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
            }
            HStack {
                NavigationLink(destination: HomeView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(Color(hex: "#E8FAF4"))
                            .shadow(color: Color(hex: "#E8FAF4").opacity(0.25), radius: 24, x: 4, y: 8)
                            .frame(width: 140, height: 65)
                            .padding()
                        
                        Text("Skip")
                            .foregroundColor(Color(hex: "#17CE92"))
                            .font(.system(size: 18, weight: .bold))
                    }
                    .padding(.top, 10)
                }
                NavigationLink(destination: HomeView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(Color(hex: "#17CE92"))
                            .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                            .frame(width: 140, height: 65)
                            .padding()
                        
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.bottom, 10)
        }
        .ignoresSafeArea()
        .padding(.horizontal)
        .padding(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

struct CompleteYourProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteYourProfileView(viewModel: RegisterUserVM())
    }
}



