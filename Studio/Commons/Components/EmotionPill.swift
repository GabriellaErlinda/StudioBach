//
//  EmotionPill.swift
//  Studio
//
//  Created by Gabriella Erlinda on 03/05/26.
//

import SwiftUI

struct EmotionPill: View {

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "drop.degreesign.fill")
                .foregroundColor(.white)
            
            Text("Sad")
                .bold()
                .foregroundColor(.white)
            
        }
        .padding()
        .background(
            ZStack {
                Color("blue-ribbon-950")
                    .opacity(0.2)
                
                RoundedRectangle(cornerRadius: 24)
                    .glassEffect(.clear, in: .capsule)
            }
        )
    }
}

#Preview {
    EmotionPill()
        .background(Color.black)
}

