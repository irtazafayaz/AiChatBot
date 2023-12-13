//
//  CustomImagePicker.swift
//  AiChatBot
//
//  Created by Moeed Khan on 13/12/2023.
//

import SwiftUI
import PhotosUI

extension View{
    @ViewBuilder
    func cropImagePicker(options: [Crop],show: Binding<Bool>,croppedImage:
                         Binding<UIImage?>)->some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    @ViewBuilder
    func frame(_ size: CGSize)-> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    func haptic (_ style: UIImpactFeedbackGenerator.FeedbackStyle){
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    var options:[Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    init(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self.options = options
        self._show = show
        self._croppedImage = croppedImage
    }
    
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .square
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { newValue in
                if let newValue{
                    Task{
                        if let imageData = try? await
                            newValue.loadTransferable(type: Data.self), let image =
                            UIImage(data: imageData){
                            await MainActor.run(body: {
                                selectedImage = image
                                showDialog.toggle()
                            })
                        }
                    }
                }
            }
            .confirmationDialog("", isPresented: $showDialog){
                ForEach(options.indices,id: \.self){index in
                    Button(options[index].name()){
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                selectedImage = nil
            } content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage{
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

struct CropView: View{
    var crop: Crop
    var image: UIImage?
    var onCrop: (UIImage?, Bool)->()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View{
        NavigationStack{
            ImageView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .background{
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content:  ImageView(true))
                            renderer.proposedSize = .init(crop.size())
                            if let image = renderer.uiImage{
                                onCrop(image,true)
                            } else {
                                onCrop(nil,false)
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false)->some View{
        let cropSize = crop.size()
        GeometryReader{
            let size = $0.size
            
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader {proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptic(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.width = (offset.height - rect.minY)
                                            haptic(.medium)
                                        }
                                        
                                        if rect.maxX < size.width{
                                            offset.width = (rect.minX - offset.width)
                                            haptic(.medium)
                                        }
                                        
                                        if rect.maxY < size.height{
                                            offset.height = (rect.minY - offset.height)
                                            haptic(.medium)
                                        }
                                        
                                    }
                                }
                        }
                    })
                    .frame(size)
                    .onChange(of: isInteracting) { newValue in
                        
                        if !newValue{
                            lastStoredOffset = offset
                        }
                    }
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay(content: {
            if !hideGrids {
                Grids()
            }
        })
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width,
                                    height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)){
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        
        .frame(cropSize)
        .cornerRadius(crop == .square ? cropSize.height / 2 : 0)
    }
    
    @ViewBuilder
    func Grids()->some View{
        ZStack{
            HStack{
                ForEach(1...5,id: \.self){_ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            VStack{
                ForEach(1...5,id: \.self){_ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }

        }
    }
}
#Preview {
    ContentView()
}