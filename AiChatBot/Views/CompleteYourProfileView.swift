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
    
    @State private var isLoading = false

    
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedGender = ""
    @State private var selectedDate = Date()
    
    var genders = ["Male", "Female", "Other"] // Example gender options
    
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
                        .font(.headline)
                    HStack {
                        TextField("Full Name", text: $fullName)
                        Image("ic_dropdown")
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                    .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
                // MARK: Phone Number Text Field
                
                VStack(alignment: .leading) {
                    Text("Phone Number")
                        .font(.headline)
                    iPhoneNumberField("(000) 000-0000", text: $phoneNumber)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .font(Font.custom("Urbanist-Bold", size: 20))
                        .padding(.bottom, 10)
                        .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
                // MARK: Gender
                
                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(.headline)
                    Menu("Gender", content: {
                        
                        ForEach(self.genders, id: \.self, content: { gender in
                            Button(action: {
                                selectedGender = gender
                            }) {
                                Label(gender, systemImage: "person")
                            }
                        })
                        
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    .underlinedTextFieldStyle()
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading) {
                    Text("Date")
                        .font(.headline)
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .accentColor(.red) // Set the desired color for the divider
                        .foregroundColor(.blue)
                    
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "#17CE92"))
                        .padding(.top, 5)
                    
                }
                .padding(.top, 10)
            }
            HStack {
                NavigationLink(destination: LoginView()) {
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
                NavigationLink(destination: LoginView()) {
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
        CompleteYourProfileView()
    }
}



