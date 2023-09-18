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
    
    //MARK: - Data Members -
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var viewModel: ChatVM = ChatVM(with: "")
    @State private var isEditing: Bool = false
    @State var isPaywallPresented = false
    @State var isAdShown = false
    @State private var paywallMsgDisplayed: Bool = false
    @State private var emptyString: String = ""
    var predefinedMessage: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    //MARK: Core Data
    @FetchRequest(sortDescriptors: []) var chatHistory: FetchedResults<ChatHistory>
    @Environment(\.managedObjectContext) var moc
    
    //MARK: Export PDF
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale
    @State private var isShowingDocumentPicker = false
    
    //MARK: Image Picker
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @ObservedObject var webSocket = WebSocket()
    
    //MARK: - Initialization Methods -
    
    init(messagesArr: [MessageWithImages] = []) {
        _viewModel = StateObject(wrappedValue: ChatVM(with: "", messages: messagesArr))
    }
    
    var body: some View {
        VStack {
            if !viewModel.msgsArr.isEmpty {
                chatListWithImagesView
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
                    Text("School AI")
                        .font(Font.custom(FontFamily.bold.rawValue, size: 24))
                        .foregroundColor(Color(hex: "#FFFFFF"))
                }
            })
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePicker(selectedImage: self.$selectedImage, sourceType: self.sourceType, viewModel: viewModel)
        }
    }
    
    //MARK: - Custom UIs -
    
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
    
    var chatListWithImagesView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.msgsArr.filter({$0.role != .system}), id: \.id) { message in
                            getMessageViewWithImage(message)
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
            .onChange(of: viewModel.msgsArr.filter({$0.role != .system}).last?.content) { _ in  scrollToBottom(proxy: proxy)
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
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            } label: {
                Circle()
                    .fill(Color(hex: Colors.primary.rawValue))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    )
            }
            
            Button {
                Task { @MainActor in
                    isTextFieldFocused = false
                    if proxy != nil {
                        scrollToBottom(proxy: proxy!)
                    }
                    let newMessage = MessageWithImages(id: UUID().uuidString, content: .text(self.viewModel.currentInput), createdAt: Date(), role: .user, sessionID: viewModel.getSession())
                    addToCoreData(message: newMessage)
                    viewModel.msgsArr.append(newMessage)
                    
                    viewModel.sendMessageUsingFirebase { success in
                        guard let resp = success else { return }
                        addToCoreData(message: resp)
                    }
                }
            } label: {
                Circle()
                    .fill(Color(hex: Colors.primary.rawValue))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image("ic_send_btn_icon")
                            .resizable()
                            .scaledToFit()
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    )
            }
            .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.top, 12)
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
    
    func getMessageViewWithImage(_ message: MessageWithImages) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            HStack {
                switch message.content {
                case .text(let content):
                    Text(content)
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
                            DocumentPicker(isShowingPicker: $isShowingDocumentPicker, pdfData: createPDF(text: content))
                        }
                    }
                case .image(let data):
                    Image(uiImage: UIImage(data: data) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(RoundedCorners(
                            tl: message.role == .user ? 20 : 8,
                            tr: 20,
                            bl: 20,
                            br: message.role == .user ? 8 : 20
                        ).fill(message.role == .user ? Color(hex: Colors.primary.rawValue) : Color(hex: "#F5F5F5")))
                }
            }
            if message.role == .assistant || message.role == .paywall {
                Spacer()
            }
        }
        .padding(.vertical, 10)
    }
    
    //MARK: - Render text to PDF -
    
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
        let pdfData = NSMutableData()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 300, height: 500), format: format)
        let pageInfo = PDFPageInfo(text: text)
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.pdf")
        do {
            try renderer.writePDF(to: fileURL) { context in
                context.beginPage()
                pageInfo.draw(in: context.cgContext)
            }
        } catch {
            print("Error writing PDF: \(error)")
        }
        if let fileData = try? Data(contentsOf: fileURL) {
            pdfData.append(fileData)
        }
        return pdfData as Data
    }
    
    //MARK: - Actions -
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = viewModel.messages.filter({$0.role != .system}).last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
    
    func addToCoreData(message: MessageWithImages) {
        let chat = ChatHistory(context: moc)
        chat.id = UUID()
        if case .text(let text) = message.content {
            chat.message = text
        } else if case .image(let imageData) = message.content {
            chat.imageData = imageData
        }
        chat.role = message.role.rawValue
        chat.createdAt = Date()
        chat.sessionID = message.sessionID
        try? moc.save()
    }
    
    func generatePDF() {
        isShowingDocumentPicker = true
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
