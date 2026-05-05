import SwiftUI
import UniformTypeIdentifiers

struct AddFilePopupView: View {
    @Binding var isPresented: Bool
    @State private var isFileImporterPresented = false
    
    var body: some View {
        ZStack/*(alignment: .bottom)*/ {
            // Backdrop
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Popup Box
            VStack(spacing: 24) {
                // Icon
                Image(systemName: "music.note.list")
                    .font(.system(size: 48))
                    .foregroundColor(Color("blue-ribbon-500"))
                    .shadow(color: Color("blue-ribbon-400").opacity(0.5), radius: 10, x: 0, y: 5)
                
                // Texts
                VStack(spacing: 8) {
                    Text("Import Audio File")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Select an audio file from your device to use in this project.")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        isFileImporterPresented = true
                    }) {
                        Text("Browse Files")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color("blue-ribbon-400")))
                    }
                    
                    Button(action: {
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(Color.white.opacity(0.1)))
                            .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    }
                }
            }
            .padding(32)
            .background(
                LinearGradient(
                    colors: [Color("blue-ribbon-950").opacity(0.8), Color("primary-950").opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .glassEffect(.clear, in: .rect(cornerRadius: 32))
            .padding(.horizontal, 32)
            .padding(.bottom, 0)
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            // TODO: handling file selection
            withAnimation {
                isPresented = false
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AddFilePopupView(isPresented: .constant(true))
    }
}
