import SwiftUI

struct SplashView: View {
    
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(AppImages.logo.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
            
            Text("ChattyAI")
                .font(Font.custom(FontFamily.bold.rawValue, size: 40))
                .foregroundColor(Color(hex: Colors.labelDark.rawValue))
                .multilineTextAlignment(.center)
                .frame(width: 164, height: 64)
            
            Spacer()
            
            if isLoading {
                LoadingView()
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 50)
            }
        }
        .onAppear {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
