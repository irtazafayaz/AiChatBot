//
//  ContentView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 25/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginIntroView()
    }
}

//
//struct ContentView: View {
//
//    @State private var text = "Your text here"
//    @State private var renderedImage = Image(systemName: "photo")
//    @Environment(\.displayScale) var displayScale
//
//    var body: some View {
//        GeometryReader { proxy in
//            let size = proxy.size
//            VStack {
//                renderedImage
//                ShareLink("Export", item: renderedImage, preview: SharePreview(Text("Shared image"), image: renderedImage))
//                TextField("Enter some text", text: $text)
//                    .textFieldStyle(.roundedBorder)
//                    .padding()
//            }
//            .onChange(of: text) { _ in render(viewSize: size) }
//            .onAppear { render(viewSize: size) }
//        }
//    }
//
//    @MainActor func render(viewSize: CGSize) {
//        let renderer = ImageRenderer(
//            content: PDFView(text: "shgfdhasgfjd h fgjahdgsfhjdjgfjhsd hfgdsjhfgjdsfhgjsdfgfdhsgfjhsdgfj")
//                .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
//        )
//        renderer.scale = displayScale
//        if let uiImage = renderer.uiImage {
//            renderedImage = Image(uiImage: uiImage)
//        }
//    }
//}
