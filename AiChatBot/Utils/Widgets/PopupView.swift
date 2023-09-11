//
//  PopupView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 11/09/2023.
//

import SwiftUI

struct PopupView: View {
    var title: String
    var message: String
    var buttonText: String
    @Binding var show: Bool
    var body: some View {

        ZStack {
            if show {
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 0) {
                    LoadingView()
                    Button(action: {
                        withAnimation(.linear(duration: 0.3)) {
                            show = false
                        }
                    }, label: {
                        Text(buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
                            .font(Font.system(size: 23, weight: .semibold))
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
                    }).buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: 300)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            }

        }
    }
}

//struct PopupView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopupView(title: "", message: "", buttonText: "", show: true)
//    }
//}
