//
//  ImageCropperView.swift
//  AiChatBot
//
//  Created by Moeed Khan on 15/12/2023.
//

import SwiftUI
import TOCropViewController


struct ImageCropperView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var croppedImage: UIImage?
    @ObservedObject var viewModel: ChatVM

    var onDismiss: () -> Void
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) var moc

    func makeUIViewController(context: Context) -> TOCropViewController {
        let cropViewController = TOCropViewController(image: image ?? UIImage())
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TOCropViewControllerDelegate {
        var parent: ImageCropperView

        init(_ parent: ImageCropperView) {
            self.parent = parent
        }

      func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            parent.croppedImage = image
            self.addImage(selectedImage: parent.croppedImage ?? UIImage())
            parent.onDismiss()
        }
        
        func addToCoreData(message: MessageWithImages) {
            let chat = ChatHistory(context: self.parent.moc)
            chat.id = UUID()
            if case .text(let text) = message.content {
                chat.message = text
            } else if case .image(let imageData) = message.content {
                chat.imageData = imageData
            }
            chat.role = message.role.rawValue
            chat.createdAt = Date()
            chat.sessionID = message.sessionID
            chat.address = UserDefaults.standard.loggedInEmail
            try? self.parent.moc.save()
        }
        
        func addImage(selectedImage: UIImage) {
            DispatchQueue.main.async {
                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                    print("Image converted to data successfully.")
                    let newImageMessage = MessageWithImages(id: UUID().uuidString, content: .image(imageData), createdAt: Date(), role: .user, sessionID: self.parent.viewModel.getSession())
                    let typingMsg = MessageWithImages(id: UUID().uuidString, content: .text("typing..."), createdAt: Date(), role: .assistant, sessionID: self.parent.viewModel.getSession())
                    self.addToCoreData(message: newImageMessage)
                    self.parent.viewModel.msgsArr.append(newImageMessage)
                    self.parent.viewModel.msgsArr.append(typingMsg)
                    self.parent.viewModel.sendImage(image: selectedImage) { msg in
                        _ = self.parent.viewModel.msgsArr.popLast()
                        if let message = msg {
                            self.addToCoreData(message: message)
                            DispatchQueue.main.async {
                                self.parent.viewModel.msgsArr.append(message)
                            }
                        }
                    }
                } else {
                    print("Failed to convert image to data.")
                }
            }
        }
    }
}
