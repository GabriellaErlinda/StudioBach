//
//  EmotionDetailCard.swift
//  Minty
//
//  Created by Nickson Leviel on 04/05/26.
//

import SwiftUI

struct EmotionPill: View {
    
    let emotion: String
    let iconName: String
    
    var body: some View {
        
        HStack {
            Image(systemName: iconName)
            Text(emotion)
        }
        .padding()
        .foregroundStyle(.white)
        .fontWeight(.bold)
//        .glassEffect(.clear)
        .background(Color("blue-ribbon-400"))
        .clipShape(RoundedRectangle(cornerRadius: 48))
    }
}

#Preview {
    EmotionPill(emotion: "Happy", iconName: "face.smiling")
}
