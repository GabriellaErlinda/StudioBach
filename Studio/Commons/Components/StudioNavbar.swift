//
//  NavBar.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI

struct StudioNavbar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @State private var showInfo = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image("logo_inline")
                        .resizable()
                        .fontWeight(.bold)
                        .frame(width: 120, height: 41)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showInfo = true }) {
                        Image(systemName: "info")
                    }
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
