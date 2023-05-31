//
//  LoginViewModel.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 30/05/2023.
//

import Foundation
import SwiftUI

class LoginVM: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible = false
    @Published var isAgreed = false
    @Published var loginActionSuccess: Bool = false
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            self.loginActionSuccess = true
        }
    }

}
