//
//  ImagePicker.swift
//  SocialNetwork
//
//  Created by Adnan Afzal on 30/10/2020.
//  Copyright © 2020 Adnan Afzal. All rights reserved.
//

import Foundation
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) var moc
    var sourceType: UIImagePickerController.SourceType
    @ObservedObject var viewModel: ChatVM

    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }

}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var picker: ImagePicker
    
    init(picker: ImagePicker) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        self.picker.selectedImage = selectedImage
        self.picker.viewModel.getMessageObject()
        self.addImage(selectedImage: selectedImage)
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
    func addToCoreData(message: MessageWithImages) {
        let chat = ChatHistory(context: self.picker.moc)
        chat.id = UUID()
        if case .text(let text) = message.content {
            chat.message = text
        } else if case .image(let imageData) = message.content {
            chat.imageData = imageData
        }
        chat.role = message.role.rawValue
        chat.createdAt = Date()
        chat.sessionID = Double(UserDefaults.standard.sessionID)
        try? self.picker.moc.save()
    }
    
    func addImage(selectedImage: UIImage) {
        DispatchQueue.main.async {
            if let imageData = selectedImage.pngData() {
                print("Image converted to data successfully.")
                let newImageMessage = MessageWithImages(id: UUID().uuidString, content: .image(imageData), createdAt: Date(), role: .user)
                self.addToCoreData(message: newImageMessage)
                self.picker.viewModel.sendImage(image: selectedImage) { msg in
                    if let message = msg {
                        self.addToCoreData(message: message)
                        self.picker.viewModel.msgsArr.append(message)
                    }
                }
                DispatchQueue.main.async {
                    self.picker.viewModel.msgsArr.append(newImageMessage)
                }
            } else {
                print("Failed to convert image to data.")
            }
        }
    }
    
    
}
