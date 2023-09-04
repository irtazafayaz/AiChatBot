//
//  ChatView.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 06/06/2023.
//

import SwiftUI
import PDFKit
import UIKit

struct ChatView: View {
    
    //MARK: Data Members
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject private var viewModel: ChatVM
    @State private var isEditing: Bool = false
    @State private var convoStarted: Bool = true
    @State var isPaywallPresented = false
    @State var isAdShown = false
    @State private var paywallMsgDisplayed: Bool = false
    @State private var emptyString: String = ""
    var predefinedMessage: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    //MARK: Export PDF
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale
    @State private var isShowingDocumentPicker = false
    
    //MARK: Image Picker
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    //MARK: Initialization Methods
    init() {
        viewModel = ChatVM(with: "")
    }
    
    var body: some View {
        VStack {
            if convoStarted {
                chatListView
            } else {
                chatNorStartedView
            }
        }
        .padding(.horizontal, 10)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                HStack {
                    CustomBackButton()
                    Text("BROO")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: "#FFFFFF"))
                }
            })
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }
    
    var chatNorStartedView: some View {
        VStack {
            Image("ic_app_logo_gray")
                .padding(.top, 50)
            Text("Capabilities")
                .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                .foregroundColor(Color(hex: "BDBDBD"))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            VStack {
                Text("Answer all your questions.\n(Just ask me anything you like!)")
                    .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                    .foregroundColor(Color(hex: "9E9E9E"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedCorners(
                        tl: 10,
                        tr: 10,
                        bl: 10,
                        br: 10
                    ).fill(Color(hex: Colors.chatBG.rawValue)))
                
                Text("Generate all the text you want.\n(essays, articles, reports, stories, & more)")
                    .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                    .foregroundColor(Color(hex: "9E9E9E"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedCorners(
                        tl: 10,
                        tr: 10,
                        bl: 10,
                        br: 10
                    ).fill(Color(hex: Colors.chatBG.rawValue)))
                
                Text("Conversational AI.\n(I can talk to you like a natural human)")
                    .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                    .foregroundColor(Color(hex: "9E9E9E"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedCorners(
                        tl: 10,
                        tr: 10,
                        bl: 10,
                        br: 10
                    ).fill(Color(hex: Colors.chatBG.rawValue)))
            }
            .padding()
            
            
            Text("These are just a few examples of what I can do.")
                .font(Font.custom(FontFamily.medium.rawValue, size: 16))
                .foregroundColor(Color(hex: "9E9E9E"))
            
            Spacer()
            Divider()
            bottomView(image: "profile", proxy: nil)
        }
        
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                            getMessageView(message)
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
            }
            .onChange(of: viewModel.messages.filter({$0.role != .system}).last?.content) { _ in  scrollToBottom(proxy: proxy)
            }
        }
        
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy?) -> some View {
        HStack(alignment: .top, spacing: 8) {
            
            TextField("Message...", text: $viewModel.currentInput, onEditingChanged: { editing in
                isEditing = editing
            })
            .foregroundColor(.black)
            .padding()
            .frame(minHeight: CGFloat(30))
            .background(Color(hex: "#1417CE92"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEditing ? Color(hex: Colors.primary.rawValue) : Color.clear, lineWidth: 2)
            )
            .onChange(of: viewModel.currentInput) { newValue in
                if newValue.isEmpty && !isEditing {
                    viewModel.currentInput = ""
                }
            }
            .focused($isTextFieldFocused)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            Button {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            } label: {
                Image("ic_send_btn_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            
            Button {
                Task { @MainActor in
                    convoStarted = true
                    isTextFieldFocused = false
                    if proxy != nil {
                        scrollToBottom(proxy: proxy!)
                    }
                    viewModel.sendMessage()
                }
            } label: {
                Image("ic_send_btn_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
        }
        .padding(.top, 12)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = viewModel.messages.filter({$0.role != .system}).last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    func getMessageView(_ message: Message) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            Text(message.content)
                .font(.custom(FontFamily.medium.rawValue, size: 18))
                .foregroundColor(message.role == .user ? .white : .black)
                .padding()
                .background(RoundedCorners(
                    tl: message.role == .user ? 20 : 8,
                    tr: 20,
                    bl: 20,
                    br: message.role == .user ? 8 : 20
                ).fill(message.role == .user ? Color(hex: Colors.primary.rawValue) : Color(hex: "#F5F5F5")))
            if message.role == .assistant {
                Button(action: {
                    generatePDF()
                }, label: {
                    Image("ic_copy")
                })
                .padding()
                .sheet(isPresented: $isShowingDocumentPicker) {
                    DocumentPicker(isShowingPicker: $isShowingDocumentPicker, pdfData: createPDF(text: message.content))
                }
            }
            if message.role == .assistant || message.role == .paywall {
                Spacer()
            }
        }
        .padding(.vertical, 10)
    }
    
    @MainActor func render(viewSize: CGSize) {
        let renderer = ImageRenderer(
            content: PDFView(text: "shgfdhasgfjd h fgjahdgsfhjdjgfjhsd hfgdsjhfgjdsfhgjsdfgfdhsgfjhsdgfj")
                .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
        )
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
    
    private func createPDF(text: String) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Your App Name",
            kCGPDFContextAuthor: "Your Name",
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pdfData = NSMutableData() // Create NSMutableData instance
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 300, height: 500), format: format)
        
        let pageInfo = PDFPageInfo(text: text)
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.pdf")
        
        // Use fileURL in the writePDF function
        do {
            try renderer.writePDF(to: fileURL) { context in
                context.beginPage()
                pageInfo.draw(in: context.cgContext)
            }
        } catch {
            print("Error writing PDF: \(error)")
        }
        
        
        // Read data from the file and append it to pdfData
        if let fileData = try? Data(contentsOf: fileURL) {
            pdfData.append(fileData)
        }
        
        return pdfData as Data
    }
    
    func generatePDF() {
        isShowingDocumentPicker = true
    }
    
    
    //MARK: Send JPEG to Server
    
    func sendImageToServer() {
        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 1.0) {
            let url = URL(string: "https://yourserver.com/upload")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set appropriate headers if needed
            // request.setValue("application/jpeg", forHTTPHeaderField: "Content-Type")
            
            // Attach image data to the request body
            request.httpBody = imageData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    // Handle the response from the server if necessary
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                }
            }
            
            task.resume()
        }

    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}


struct RenderView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(text)
                .font(.largeTitle)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}



//
//VStack {
//
//    if selectedImage != nil {
//        Image(uiImage: selectedImage!)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .clipShape(Circle())
//            .frame(width: 300, height: 300)
//    } else {
//        Image(systemName: "snow")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .clipShape(Circle())
//            .frame(width: 300, height: 300)
//    }
//
//    Button("Camera") {
//        self.sourceType = .camera
//        self.isImagePickerDisplay.toggle()
//    }.padding()
//
//    Button("photo") {
//        self.sourceType = .photoLibrary
//        self.isImagePickerDisplay.toggle()
//    }.padding()
//}
//.navigationBarTitle("Demo")
//.sheet(isPresented: self.$isImagePickerDisplay) {
//    ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType)
//}
