//
//  RegisterUserVM.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 01/06/2023.
//

import Foundation

class RegisterUserVM: ObservableObject {
    
    //MARK: RegisterView
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible = false
    @Published var isAgreed = false
    @Published var registerActionSuccess = false
    
    //MARK: CompleteYourProfileView
    @Published var isLoading = false
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedGender = ""
    @Published var selectedDate = Date()
    
    let genders = ["Male", "Female", "Other"]
    
    func registerUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.registerActionSuccess = true
        })
    }
    
}
