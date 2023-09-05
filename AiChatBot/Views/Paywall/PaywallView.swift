//
//  PaywallView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 05/09/2023.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    
    @Binding var isPaywallPresented: Bool
    @State var currentOffering: Offering?
    @State var selectedPackage: Package?
    @State var isHideLoader: Bool = true
    
    @State private var message = "Subscription Activated"
    @State private var showAlert = false
    @State var goBack = false

    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack {
            VStack (alignment: .leading, spacing: 20) {
                
                Text("Unlock Unlimited Access")
                    .font(Font.custom(FontFamily.bold.rawValue, size: 30))
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .center) {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("Answers from GPT3.5")
                                .font(Font.custom(FontFamily.semiBold.rawValue, size: 20))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                            Text("More accurate & detailed answers")
                                .font(Font.custom(FontFamily.regular.rawValue, size: 12))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                    }
                    HStack(alignment: .center) {
                        Image(systemName: "checkmark.icloud")
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("Higher word limit")
                                .font(Font.custom(FontFamily.semiBold.rawValue, size: 20))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                            Text("Type longer messages")
                                .font(Font.custom(FontFamily.regular.rawValue, size: 12))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                    }
                    HStack(alignment: .center) {
                        Image(systemName: "shareplay")
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("No Limits")
                                .font(Font.custom(FontFamily.semiBold.rawValue, size: 20))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                            Text("Have unlimited dialogues")
                                .font(Font.custom(FontFamily.regular.rawValue, size: 12))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                    }
                    HStack(alignment: .center) {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.white)
                        VStack(alignment: .leading) {
                            Text("No Ads")
                                .font(Font.custom(FontFamily.semiBold.rawValue, size: 20))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                            Text("Enjoy School AI without any ads")
                                .font(Font.custom(FontFamily.regular.rawValue, size: 12))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                
//                if isHideLoader {
//                    if currentOffering != nil {
//                        ForEach(currentOffering!.availablePackages) { pkg in
//                            Button {
//                                selectedPackage = pkg
//                            } label: {
//                                VStack(alignment: .leading) {
//                                    HStack {
//                                        VStack(alignment: .leading) {
//                                            Text(
//                                                pkg.storeProduct.subscriptionPeriod?.periodTitle == nil ? NSLocalizedString("paywall_onetime_heading", comment: "") :
//                                                    NSLocalizedString("paywall_weekly_heading", comment: "")
//                                            )
//                                            .foregroundColor(.white)
//                                            .font(Font.custom(FontFamily.regular.rawValue, size: 12))
//
//                                            Text("\(pkg.storeProduct.localizedPriceString)/")
//                                                .foregroundColor(.white)
//                                                .font(Font.custom(FontFamily.bold.rawValue, size: 18))
//
//                                            +
//                                            Text(pkg.storeProduct.subscriptionPeriod?.periodTitle == nil ? NSLocalizedString("paywall_onetime_subheading", comment: "") : NSLocalizedString("paywall_weekly_subheading", comment: ""))
//                                                .foregroundColor(.white)
//                                                .font(Font.custom(FontFamily.bold.rawValue, size: 18))
//                                        }
//
//                                        Spacer()
//
//                                        if pkg.storeProduct.subscriptionPeriod?.periodTitle == nil {
//                                            Text("indrim 70%")
//                                                .padding(.horizontal, 10)
//                                                .padding(.vertical, 5)
//                                                .background(.white)
//                                                .foregroundColor(.black)
//                                                .cornerRadius(10)
//                                        }
//                                    }
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color.gray.opacity(0.2))
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke(Color(hex: Colors.primary.rawValue), lineWidth: selectedPackage == pkg ? 2 : 0)
//                                        )
//                                )
//                                .cornerRadius(10)
//                            }
//                        }
//                    }
//                } else {
//                    VStack(alignment: .center) {
//                        LoadingView().hidden(isHideLoader)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.top, 40)
//
//                }

                Spacer()
                
                Button {
                    isHideLoader = false
                    guard let pkg = selectedPackage else { return }
                    Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                        withAnimation {
                            isHideLoader = false
                        }
                        if let errorInfo = error {
                            message = errorInfo.localizedDescription
                            showAlert.toggle()
                        }
                        else if Utilities.updateCustumerInCache(cust: customerInfo) {
                            message = "Subscription Purchased."
                            showAlert.toggle()
                            self.goBack = true
                        } else {
                            message = "No active subscriptions"
                            showAlert.toggle()
                        }
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(height: 55)
                            .foregroundColor(Color(hex: Colors.primary.rawValue))
                            .cornerRadius(10)
                        Text("Start Free Trial and Plan")
                            .font(Font.custom(FontFamily.semiBold.rawValue, size: 20))
                            .foregroundColor(.white)
                        
                    }
                }
                .disabled(!isHideLoader)
 
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .background(.black)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image("ic_back_arrow")
                                .foregroundColor(.white)
                        }
                        Text("School AI")
                            .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                            .foregroundColor(Color(hex: "#FFFFFF"))
                    }
                })
            }
            .onAppear {
                Purchases.shared.getOfferings { offerings, error in
                    if let offer = offerings?.current, error == nil {
                        currentOffering = offer
                    }
                }
            }
            .alert(message, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if self.goBack {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct Paywall_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(isPaywallPresented: .constant(false))
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
