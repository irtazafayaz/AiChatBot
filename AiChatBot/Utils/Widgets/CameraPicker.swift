//
//  CameraPicker.swift
//  AiChatBot
//
//  Created by Moeed Khan on 13/12/2023.
//


import Foundation
import SwiftUI

struct CameraPicker: View {
    @State private var showPicker: Bool = true
    @State private var croppedImage: UIImage?
    var body: some View {
        NavigationStack {
            VStack{
                if let croppedImage{
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 400)
                }
            }
            .cropImagePicker(options: [.square, .rectangle], show: $showPicker, croppedImage: $croppedImage)
        }
        .navigationBarBackButtonHidden()
        .background{
            Color.black
        }
    }
}
