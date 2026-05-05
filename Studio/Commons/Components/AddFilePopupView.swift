import SwiftUI
import UniformTypeIdentifiers

struct AddFilePopupView: View {
    @Binding var isPresented: Bool
    @State private var isFileImporterPresented = false
    
    var body: some View {
        ZStack {
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
                    .foregroundColor(Color(red: 0.38, green: 0.35, blue: 0.87))
                    .shadow(color: Color(red: 0.38, green: 0.35, blue: 0.87).opacity(0.5), radius: 10, x: 0, y: 5)
                
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
                            .background(Capsule().fill(Color(red: 0.38, green: 0.35, blue: 0.87)))
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
                    colors: [Color(red: 0.15, green: 0.12, blue: 0.25).opacity(0.8), Color(red: 0.08, green: 0.06, blue: 0.15).opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .glassEffect(.clear, in: .rect(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .padding(32)
        }
        .fileImporter(
            isPresented: $isFileImporterPresented,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            // Here you'd handle the file selection, e.g., passing the URL back
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
