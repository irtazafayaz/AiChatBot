//
//  DemoViewTwo.swift
//  AiChatBot
//
//  Created by Moeed Khan on 24/01/2024.
//

import SwiftUI

struct DemoViewTwo: View {
    @State var continueButton = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Various categories, get\n the best response")
                .multilineTextAlignment(.leading)
                .padding()
                .font(.title)
            Spacer()
            Button {
                continueButton.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: Colors.primary.rawValue))
                        .shadow(color: Color.green.opacity(0.25), radius: 24, x: 4, y: 8)
                        .frame(height: 65)
                        .padding()
                    
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .padding(.bottom, 5)
            
            HStack() {
                Spacer()
                Button{
                    UserDefaults.standard.set(true, forKey: "skipDemo")
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Skip Demo")
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.bottom, 5)
                .padding(.trailing, 20)
            }
        }
        .onAppear(){
            if UserDefaults.standard.bool(forKey: "skipDemo") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationDestination(isPresented: $continueButton) {
            DemoViewThree()
        }
    }
}

#Preview {
    DemoViewTwo()
}
