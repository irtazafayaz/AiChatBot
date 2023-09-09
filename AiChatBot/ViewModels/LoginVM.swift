//
//  LoginViewModel.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 30/05/2023.
//

import Foundation
import SwiftUI

class LoginVM: ObservableObject {
    
    @Published var email: String = "irtaza@gmail.com"
    @Published var password: String = "12345678"
    @Published var isPasswordVisible = false
    @Published var isAgreed = false
    @Published var loginActionSuccess: Bool = false
    
    private let service = BaseService.shared
    
    func createParams() -> [String: String] {
        var params = [String: String]()
        params["email"] = email.lowercased()
        params["password"] = password
        return params
    }
    
    func login() {
        service.login(from: .login, params: createParams()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print("API RESPONSE \(response)")
                UserDefaults.standard.refreshToken = response.refreshToken
                self.loginActionSuccess = true
            case .failure(let error):
                print("API ERROR \(error)")
            }
        }
    }
    
    

}
