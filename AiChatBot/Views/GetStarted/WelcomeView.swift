//
//  WelcomeView.swift
//  AiChatBot
//
//  Created by Moeed Khan on 24/01/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State var getStarted = false
    @Binding var showingDemo: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack{
            VStack {
                Text("Welcome to School AI")
                    .padding()
                    .font(.title)
                Spacer()
                Button {
                    getStarted.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(hex: Colors.primary.rawValue))
                            .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                            .frame(height: 65)
                            .padding()
                        
                        Text("Get Started")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .padding(.bottom, 50)
            }
            .onAppear(){
                UserDefaults.standard.set(false, forKey: "showDemo")
                if UserDefaults.standard.bool(forKey: "skipDemo") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $getStarted) {
                DemoViewOne()
            }
        }
    }
}
