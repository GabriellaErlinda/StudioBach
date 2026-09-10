import SwiftUI

struct StudioNavbar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @State private var showInfo = false
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: { dismiss() },
                        label: {
                            Image(systemName: "chevron.backward")
                        }
                    )
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityIdentifier("navBackButton")
                }
                ToolbarItem(placement: .principal) {
                    Image("logo_inline")
                        .resizable()
                        .fontWeight(.bold)
                        .frame(width: 120, height: 41)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showInfo = true },
                           label: {
                        Image(systemName: "info")
                    }
                    )
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityIdentifier("navInfoButton")
                }
            }
            .navigationBarBackButtonHidden(true)
            .overlay {
                if showInfo {
                    // Dimmed backdrop — tap to dismiss
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation(.easeOut) { showInfo = false } }
                    // Centered card
                    InfoPopUpView(isPresented: $showInfo)
                        .padding(.horizontal, 40)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .animation(.easeOut(duration: 0.2), value: showInfo)
    }
}

extension View {
    func studioNavbar() -> some View {
        self.modifier(StudioNavbar())
    }
}
