//
//  NavBar.swift
//  Studio
//
//  Created by Nickson Leviel on 05/05/26.
//

import SwiftUI

struct StudioNavbar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("STUDIO")
                        .foregroundStyle(Color(red: 0.529, green: 0.6, blue: 0.937))
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "info")
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func studioNavbar() -> some View {
        self.modifier(StudioNavbar())
    }
}
