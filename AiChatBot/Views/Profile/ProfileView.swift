//
//  ProfileView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 05/09/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @State var isPaywallPresented = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @ObservedObject private var viewModel: ProfileVM
    @Environment(\.presentationMode) var presentationMode
    
    init () {
        self.viewModel = ProfileVM()
    }
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                
                HStack(spacing: 10) {
                    Image("ic_profile")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text(UserDefaults.standard.fullName)
                            .font(Font.custom(FontFamily.bold.rawValue, size: 20))
                            .foregroundColor(Color(hex: "#212121"))
                        Text(UserDefaults.standard.loggedInEmail)
                            .font(Font.custom(FontFamily.medium.rawValue, size: 14))
                            .foregroundColor(Color(hex: "#616161"))
                            .padding(.top, 2)
                    }
                }
                Button {
                    isPaywallPresented.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image("ic_paywall")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading) {
                            Text("Upgrade to PRO!")
                                .font(Font.custom(FontFamily.bold.rawValue, size: 20))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                            Text("Enjoy all benefits without restrictions")
                                .font(Font.custom(FontFamily.semiBold.rawValue, size: 12))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                        Spacer()
                        Image("ic_arrow_right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedCorners(
                        tl: 10,
                        tr: 10,
                        bl: 10,
                        br: 10
                    ).fill(Color(hex: "#17CE92")))
                    .padding(.top, 20)
                }
                
                Button {
                    showTerms.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image("ic_help_center")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 20)
                        Text("Terms and Conditions")
                            .font(Font.custom(FontFamily.bold.rawValue, size: 18))
                            .foregroundColor(Color(hex: Colors.labelDark.rawValue))
                            .padding(.leading, 10)
                        Spacer()
                        Image("ic_arrow_right")
                            .foregroundColor(.black)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                }
                
                Button {
                    showPrivacy.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image("ic_privacy_policy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 20)
                        Text("Privacy Policy")
                            .font(Font.custom(FontFamily.bold.rawValue, size: 18))
                            .foregroundColor(Color(hex: Colors.labelDark.rawValue))
                            .padding(.leading, 10)
                        Spacer()
                        Image("ic_arrow_right")
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                
                Button {
                    viewModel.logout { success in
                        if success {
                            viewModel.goToLogin.toggle()
                        }
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image("ic_logout")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 20)
                        Text("Logout")
                            .font(Font.custom(FontFamily.bold.rawValue, size: 18))
                            .foregroundColor(Color(hex: "#F75555"))
                            .padding(.leading, 10)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isPaywallPresented, destination: {
                PaywallView(isPaywallPresented: $isPaywallPresented)
            })
            .navigationDestination(isPresented: $viewModel.goToLogin, destination: {
                LoginRegisterSelectionView()
            })
            .sheet(isPresented: $showTerms, content: {
                SharedWebView(pageType: .terms)
            })
            .sheet(isPresented: $showPrivacy, content: {
                SharedWebView(pageType: .privacy)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Image("ic_app_logo_small")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                })
                ToolbarItem(placement: .principal, content: {
                    Text("Account")
                        .font(Font.custom(FontFamily.medium.rawValue, size: 20))
                        .foregroundColor(Color(hex: "#000000"))
                })
            }
            
            PopupView(show: $viewModel.showPopUp)
            
        }
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
