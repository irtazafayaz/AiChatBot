//
//  RegisterPasswordVM.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 30/05/2023.
//

import Foundation
import SwiftUI

class ResetPasswordVM: ObservableObject {
    
    @Published var email: String = ""
    @Published var passwordResetActionSuccess: Bool = false

    func resetPassword() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            self.passwordResetActionSuccess = true
        }
    }
}
